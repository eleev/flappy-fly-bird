//
//  GameSceneAdapter.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class GameSceneAdapter: GameSceneProtocol {
    
    // MARK: - Properties
    
    let gravity: CGFloat = -3.0
    let playerSize = CGSize(width: 100, height: 100)
    let backgroundResourceName = "Background-Winter"
    let playerResourceName = "Bird Right"
    let floorDistance: CGFloat = 0
    
    // MARK: - Conformance to GameSceneProtocol
    
    weak var scene: SKScene?
    
    var updatables = [Updatable]()
    var touchables = [Touchable]()
    
    // MARK: - Private properties
    
    private(set) var infiniteBackgroundNode: InfiniteSpriteScrollNode?
    
    // MARK: - Initializers
    
    required init?(with scene: SKScene) {
        self.scene = scene
        
        guard let scene = self.scene else {
            debugPrint(#function + " could not unwrap the host SKScene instance")
            return nil
        }
        
        prepareWorld(for: scene)
        prepareInfiniteBackgroundScroller(for: scene)
        preparePlayer(for: scene)
        launchPipeFactory(for: scene)
    }

    // MARK: - Helpers
    
    private func prepareWorld(for scene: SKScene) {
        scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: gravity)
        let rect = CGRect(x: 0, y: floorDistance, width: scene.size.width, height: scene.size.height - floorDistance)
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        
        let boundary: PhysicsCategories = .boundary
        let player: PhysicsCategories = .player
        
        scene.physicsBody?.categoryBitMask = boundary.rawValue
        scene.physicsBody?.collisionBitMask = player.rawValue
    }
    
    private func preparePlayer(for scene: SKScene) {
        let bird = BirdNode(animationTimeInterval: 0.1, withTextureAtlas: playerResourceName, size: playerSize)
        bird.position = CGPoint(x: bird.size.width / 2 + 24, y: scene.size.height / 2)
        bird.zPosition = 10
        
        scene.addChild(bird)
        
        updatables.append(bird)
        touchables.append(bird)
    }
    
    private func prepareInfiniteBackgroundScroller(for scene: SKScene) {
        infiniteBackgroundNode = InfiniteSpriteScrollNode(fileName: backgroundResourceName, scaleFactor: CGPoint(x: 2.98, y: 2.98))
        infiniteBackgroundNode!.zPosition = 0
        
        scene.addChild(infiniteBackgroundNode!)
        updatables.append(infiniteBackgroundNode!)
    }
    
    private func launchPipeFactory(for scene: SKScene) {
        
        let topPipeName = "top-pipe"
        let bottomPipeName = "bottom-pipe"
        let thresholdPipeName = "threshold-pipe"
        
        let cleanUpBottomPipeAction = SKAction.run { [weak self] in
            self?.infiniteBackgroundNode?.childNode(withName: bottomPipeName)?.removeFromParent()
        }
        let cleanUpTopPipeAction = SKAction.run { [weak self] in
            self?.infiniteBackgroundNode?.childNode(withName: topPipeName)?.removeFromParent()
        }
        let cleanUpThresholdPipeAction = SKAction.run { [weak self] in
            self?.infiniteBackgroundNode?.childNode(withName: thresholdPipeName)?.removeFromParent()
        }
        
        let waitAction = SKAction.wait(forDuration: 3.0)
        
        let pipeMoveDuration: TimeInterval = 4.0
        
        let producePipeAction = SKAction.run { [weak self] in
            
            guard let pipes = PipeFactory.produce(sceneSize: scene.size) else {
                return
            }
            let scrollingNode = self?.infiniteBackgroundNode
            pipes.bottom.name = bottomPipeName
            pipes.top.name = topPipeName
            pipes.threshold.name = thresholdPipeName
            
            scrollingNode?.addChild(pipes.top)
            scrollingNode?.addChild(pipes.bottom)
            scrollingNode?.addChild(pipes.threshold)
            
            // Construct move actions for pipes
            let bottom = pipes.bottom
            let top = pipes.top
            let threshold = pipes.threshold
            
            let pipeBottomMoveAction = SKAction.move(to: CGPoint(x: -bottom.size.width, y: bottom.position.y), duration: pipeMoveDuration)
            let pipeTopMoveAction = SKAction.move(to: CGPoint(x: -top.size.width, y: top.position.y), duration: pipeMoveDuration)
            let pipeThresholdMoveAction = SKAction.move(to: CGPoint(x: -threshold.size.width, y: threshold.position.y), duration: pipeMoveDuration - 0.4)
            
            let pipeBottomMoveSequence = SKAction.sequence([pipeBottomMoveAction, cleanUpBottomPipeAction])
            let pipeTopMoveSequence = SKAction.sequence([pipeTopMoveAction, cleanUpTopPipeAction])
            let pipeThresholdMoveSequence = SKAction.sequence([pipeThresholdMoveAction, cleanUpThresholdPipeAction])
            
            bottom.run(pipeBottomMoveSequence)
            top.run(pipeTopMoveSequence)
            threshold.run(pipeThresholdMoveSequence)
        }
        
        let sequenceAction = SKAction.sequence([waitAction, producePipeAction])
        let infinitePipeProducer = SKAction.repeatForever(sequenceAction)
        scene.run(infinitePipeProducer)
    }
    
}
