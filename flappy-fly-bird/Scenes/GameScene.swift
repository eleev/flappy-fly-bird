//
//  GameScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Constants
    
    static var viewportSize: CGSize = .zero
    
    // MARK: - Properties
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        PlayingState(adapter: sceneAdapeter!),
        GameOverState(scene: sceneAdapeter!),
        PausedState(scene: self, adapter: sceneAdapeter!)
        ])
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    let maximumUpdateDeltaTime: TimeInterval = 1.0 / 60.0

    var sceneAdapeter: GameSceneAdapter?
    let selection = UISelectionFeedbackGenerator()

    // MARK: - Lifecycle
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.lastUpdateTime = 0
        sceneAdapeter = GameSceneAdapter(with: self)
        sceneAdapeter?.stateMahcine = stateMachine
        sceneAdapeter?.stateMahcine?.enter(PlayingState.self)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        GameScene.viewportSize = view.bounds.size
    }
    
    // MARK: - Interaction handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneAdapeter?.touchables.forEach({ touchable in
            touchable.touchesBegan(touches, with: event)
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneAdapeter?.touchables.forEach { touchable in
            touchable.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneAdapeter?.touchables.forEach { touchable in
            touchable.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneAdapeter?.touchables.forEach { touchable in
            touchable.touchesCancelled(touches, with: event)
        }
    }
    
    // MARK: - Updates
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Don't perform any updates if the scene isn't in a view.
        guard view != nil else { return }
        
        // Calculate the amount of time since `update` was last called.
        var deltaTime = currentTime - lastUpdateTime
        
        // If more than `maximumUpdateDeltaTime` has passed, clamp to the maximum; otherwise use `deltaTime`.
        deltaTime = deltaTime > lastUpdateTime ? maximumUpdateDeltaTime : deltaTime
        
        // The current time will be used as the last update time in the next execution of the method.
        lastUpdateTime = currentTime
        
        // Don't evaluate any updates if the `worldNode` is paused. Pausing a subsection of the node tree allows the `camera` and `overlay` nodes to remain interactive.
        if self.isPaused { return }
        
        // Updateh state machine
        stateMachine.update(deltaTime: deltaTime)

        // Update all the updatables
        sceneAdapeter?.updatables.filter({ return $0.shouldUpdate }).forEach({ (activeUpdatable) in
            activeUpdatable.update(currentTime)
        })
    }
}


// MARK: - Conformance to ButtonNodeResponderType
extension GameScene: ButtonNodeResponderType {
    
    func buttonTriggered(button: ButtonNode) {
        guard let identifier = button.buttonIdentifier else {
            return
        }
        selection.selectionChanged()
        
        switch identifier {
        case .pause:
            sceneAdapeter?.stateMahcine?.enter(PausedState.self)
        case .resume:
            sceneAdapeter?.stateMahcine?.enter(PlayingState.self)
        case .home:
            let sceneId = Scenes.title.getName()
            guard let gameScene = GameScene(fileNamed: sceneId) else {
                return
            }
            gameScene.scaleMode = RoutingUtilityScene.sceneScaleMode
            let transition = SKTransition.fade(withDuration: 1.0)
            transition.pausesIncomingScene = false
            transition.pausesOutgoingScene = false
            self.view?.presentScene(gameScene, transition: transition)
        case .retry:
            // Reset and enter PlayingState
            sceneAdapeter?.stateMahcine?.enter(PlayingState.self)
        default:
            // Cannot be executed from here
            debugPrint("Cannot be executed from here")
            
        }
    }
}
