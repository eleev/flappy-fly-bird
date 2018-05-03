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
    
    weak var scene: SKScene?
    
    var updatables = [Updatable]()
    var touchables = [Touchable]()
    
    // MARK: - Initializers
    
    required init(with scene: SKScene) {
        self.scene = scene
        
        guard let scene = self.scene else {
            return
        }
        prepareWorld(for: scene)
        prepareInfiniteBackgroundScroller(for: scene)
      
        preparePlayer(for: scene)
    }

    // MARK: - Helpers
    
    private func prepareWorld(for scene: SKScene) {
        let floorDistance: CGFloat = 70
        
        scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
        let rect = CGRect(x: 0, y: floorDistance, width: scene.size.width, height: scene.size.height - floorDistance)
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        
        
        let boundary: PhysicsCategories = .boundary
        let player: PhysicsCategories = .player
        
        scene.physicsBody?.categoryBitMask = boundary.rawValue
        scene.physicsBody?.collisionBitMask = player.rawValue
    }
    
    private func preparePlayer(for scene: SKScene) {
        let birdSize = CGSize(width: 100, height: 100)
        let bird = BirdNode(animationTimeInterval: 0.1, withTextureAtlas: "Bird Right", size: birdSize)
        bird.position = CGPoint(x: bird.size.width / 2 + 24, y: scene.size.height / 2)
        bird.zPosition = 10
        
        scene.addChild(bird)
        
        updatables.append(bird)
        touchables.append(bird)
    }
    
    private func prepareInfiniteBackgroundScroller(for scene: SKScene) {
        let infiniteBackgroundNode = InfiniteSpriteScrollNode(fileName: "Background-Winter", scaleFactor: CGPoint(x: 2.98, y: 2.98))
        infiniteBackgroundNode.zPosition = 0
        
        scene.addChild(infiniteBackgroundNode)
        updatables.append(infiniteBackgroundNode)
    }
    
}
