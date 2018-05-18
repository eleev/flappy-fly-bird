//
//  PipeFactory.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 03/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

struct PipeFactory {

    // MARK: - Factory Methods
    
    static func produce(sceneSize: CGSize) -> (top: PipeNode, bottom: PipeNode, threshold: SKSpriteNode)? {
        
        let pipeWidth: CGFloat = 100
        let pipeX: CGFloat = sceneSize.width
        
        let rangedHeight = CGFloat.range(min: 70, max: 850)
        let pipeBottomSize = CGSize(width: pipeWidth, height: rangedHeight)
        let pipeBottom = PipeNode(textures: (pipe: "pipe-green", cap: "cap-green"), of: pipeBottomSize, side: false)
        pipeBottom?.position = CGPoint(x: pipeX, y: (pipeBottom?.size.height)! / 2)
        
        guard let unwrappedPipeBottom = pipeBottom else {
            debugPrint(#function + " could not construct PipeNode instnace")
            return nil
        }
        
        // Threshold node - basically gap for the player bird
        let threshold = SKSpriteNode(color: .clear, size: CGSize(width: 20, height: CGFloat.range(min: 170, max: 300)))
        threshold.position = CGPoint(x: pipeX, y: (pipeBottom?.size.height)! + threshold.size.height / 2)
        
        threshold.physicsBody = SKPhysicsBody(rectangleOf: threshold.size)
        threshold.physicsBody?.categoryBitMask =  PhysicsCategories.gap.rawValue
        threshold.physicsBody?.contactTestBitMask =  PhysicsCategories.player.rawValue
        threshold.physicsBody?.collisionBitMask = 0
        threshold.physicsBody?.isDynamic = false
        threshold.zPosition = 20
        
        // Top pipe
        let topHeight = sceneSize.height - (pipeBottom?.size.height)! - threshold.size.height
        let pipeTopSize = CGSize(width: pipeWidth, height: topHeight)
        let pipeTop = PipeNode(textures: (pipe: "pipe-green", cap: "cap-green"), of: pipeTopSize, side: true)
        pipeTop?.position = CGPoint(x: pipeX, y: (pipeBottom?.size.height)! + threshold.size.height + (pipeTop?.size.height)! / 2)
        
        guard let unwrappedPipeTop = pipeTop else {
            return nil
        }
        
        return (top: unwrappedPipeTop, bottom: unwrappedPipeBottom, threshold: threshold)
    }
    
}
