//
//  GameSceneAdapter.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit
import GameplayKit

extension SKScene {
    
    /// Searches the scene for all `ButtonNode`s.
    func findAllButtonsInScene() -> [ButtonNode] {
        return ButtonIdentifier.allButtonIdentifiers.compactMap { buttonIdentifier in
            childNode(withName: "//\(buttonIdentifier.rawValue)") as? ButtonNode
        }
    }
}

class GameSceneAdapter: NSObject, GameSceneProtocol {
    
    // MARK: - Properties
    
    let gravity: CGFloat = -5.0
    let playerSize = CGSize(width: 100, height: 100)
    let backgroundResourceName = "airadventurelevel4"//"Background-Winter"
    let playerResourceName = "Bird Right"
    let floorDistance: CGFloat = 0
    
    let isSoundOn: Bool = {
        return UserDefaults.standard.bool(for: .isSoundOn)
    }()
    
    var score: Int = 0
    private(set) var scoreLabel: SKLabelNode?
    
    private(set) var scoreSound = SKAction.playSoundFileNamed("Coin.wav", waitForCompletion: false)
    private(set) var hitSound = SKAction.playSoundFileNamed("Hit_Hurt.wav", waitForCompletion: false)
    
    var bird: BirdNode?
    
    private(set) lazy var menuAudio: SKAudioNode = {
        let audioNode = SKAudioNode(fileNamed: "POL-catch-them-all-short.wav")
        audioNode.autoplayLooped = true
        audioNode.name = "manu audio"
        return audioNode
    }()
    
    private(set) lazy var playingAudio: SKAudioNode = {
        let audioNode = SKAudioNode(fileNamed: "POL-flight-master-short.wav")
        audioNode.autoplayLooped = true
        audioNode.name = "playing audio"
        return audioNode
    }()
    
    // MARK: - Conformance to GameSceneProtocol
    
    weak var scene: SKScene?
    var stateMahcine: GKStateMachine?
    
    var updatables = [Updatable]()
    var touchables = [Touchable]()
    
    /// All buttons currently in the scene. Updated by assigning the result of `findAllButtonsInScene()`.
    var buttons = [ButtonNode]()
    
    /// The current scene overlay (if any) that is displayed over this scene.
    var overlay: SceneOverlay? {
        didSet {
            // Clear the `buttons` in preparation for new buttons in the overlay.
            buttons = []
            
            // Animate the old overlay out.
            oldValue?.backgroundNode.run(SKAction.fadeOut(withDuration: 0.25)) {
                debugPrint(#function + " remove old overlay")
                oldValue?.backgroundNode.removeFromParent()
            }
            
            if let overlay = overlay, let scene = scene {
                debugPrint(#function + " added overaly")
                overlay.backgroundNode.removeFromParent()
                scene.addChild(overlay.backgroundNode)
                
                // Animate the overlay in.
                overlay.backgroundNode.alpha = 1.0
                overlay.backgroundNode.run(SKAction.fadeIn(withDuration: 0.25))
                
                buttons = scene.findAllButtonsInScene()
            }
        }
    }
    
    private var _isHUDHidden: Bool = false
    var isHUDHidden: Bool {
        get {
            return _isHUDHidden
        }
        set(newValue) {
            _isHUDHidden = newValue
            
            if let world = self.scene?.childNode(withName: "world") {
                world.childNode(withName: "Score Node")?.isHidden = newValue
                world.childNode(withName: "Pause")?.isHidden = newValue
            }
        }
    }

    
    // MARK: - Private properties
    
    private(set) var infiniteBackgroundNode: InfiniteSpriteScrollNode?
    private let notification = UINotificationFeedbackGenerator()
    private let impact = UIImpactFeedbackGenerator(style: .heavy)
    
    // MARK: - Initializers
    
    required init?(with scene: SKScene) {
        
        self.scene = scene
        
        guard let scene = self.scene else {
            debugPrint(#function + " could not unwrap the host SKScene instance")
            return nil
        }
        
        // Get acces to the score node and then get the score label since it is a child node
        if let scoreNode = scene.childNode(withName: "world")?.childNode(withName: "Score Node") {
            scoreLabel = scoreNode.childNode(withName: "Score Label") as? SKLabelNode
        }
        
        super.init()
        
        prepareWorld(for: scene)
        prepareInfiniteBackgroundScroller(for: scene)
    }
    
    convenience init?(with scene: SKScene, stateMachine: GKStateMachine) {
        self.init(with: scene)
        self.stateMahcine = stateMachine
    }
    
    // MARK: - Helpers
    
    func resetScores() {
        score = 0
        scoreLabel?.text = "Score 0"
    }
    
    func removePipes() {
        infiniteBackgroundNode?.childNode(withName: "top-pipe")?.removeFromParent()
        infiniteBackgroundNode?.childNode(withName: "bottom-pipe")?.removeFromParent()
        infiniteBackgroundNode?.childNode(withName: "threshold-pipe")?.removeFromParent()
    }
    
    private func prepareWorld(for scene: SKScene) {
        scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: gravity)
        let rect = CGRect(x: 0, y: floorDistance, width: scene.size.width, height: scene.size.height - floorDistance)
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        
        let boundary: PhysicsCategories = .boundary
        let player: PhysicsCategories = .player
        
        scene.physicsBody?.categoryBitMask = boundary.rawValue
        scene.physicsBody?.collisionBitMask = player.rawValue
        
        scene.physicsWorld.contactDelegate = self
    }
    
    private func prepareInfiniteBackgroundScroller(for scene: SKScene) {
        infiniteBackgroundNode = InfiniteSpriteScrollNode(fileName: backgroundResourceName, scaleFactor: CGPoint(x: 1.25, y: 1.25))
        infiniteBackgroundNode!.zPosition = 0
        
        scene.addChild(infiniteBackgroundNode!)
        updatables.append(infiniteBackgroundNode!)
    }
    
}


extension GameSceneAdapter: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)
        let player = PhysicsCategories.player.rawValue
        
        if collision == (player | PhysicsCategories.gap.rawValue) {
            score += 1
            scoreLabel?.text = "Score \(score)"
            
            if isSoundOn { scene?.run(scoreSound) }
            
            notification.notificationOccurred(.success)
        }
        
        if collision == (player | PhysicsCategories.pipe.rawValue) {
            // game over state, the player has touched pipe
            deadState()
            hit()
        }
        
        if collision == (player | PhysicsCategories.boundary.rawValue) {
            // game over state, the player has touched the boundary of the world (floor)
            // player's position needs to be set to the default one
            deadState()
            hit()
        }

    }
    
    // MARK: - Collision Helpers
    
    func deadState() {
        // Do not enter the same state twice
        if stateMahcine?.currentState is GameOverState {
            return
        }
        stateMahcine?.enter(GameOverState.self)
    }
    
    func hit() {
        impact.impactOccurred()
        if isSoundOn { scene?.run(hitSound)}
    }
    
}
