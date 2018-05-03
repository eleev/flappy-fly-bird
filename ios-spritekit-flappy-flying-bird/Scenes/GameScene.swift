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
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var sceneAdapeter: GameSceneAdapter?
    
    // MARK: - Lifecycle
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.lastUpdateTime = 0
        sceneAdapeter = GameSceneAdapter(with: self)
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
        sceneAdapeter?.updatables.forEach { updatable in
            updatable.update(currentTime)
        }
    }
}
