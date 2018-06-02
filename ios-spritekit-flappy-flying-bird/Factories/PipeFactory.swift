//
//  PipeFactory.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 03/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

struct PipeFactory {

    // MARK: - Typealiases
    
    typealias PipeParts = (top: PipeNode, bottom: PipeNode, threshold: SKSpriteNode)
    
    // MARK: - Factory Methods
    
    static func launch(for scene: SKScene, targetNode: SKNode) -> SKAction {
        let pipeName = "pipe"
        
        let cleanUpAction = SKAction.run {
            targetNode.childNode(withName: pipeName)?.removeFromParent()
        }
        let waitAction = SKAction.wait(forDuration: 3.0)
        
        let pipeMoveDuration: TimeInterval = 4.0
        
        let producePipeAction = SKAction.run {
            guard let pipe = PipeFactory.produceStandardPipe(sceneSize: scene.size) else {
                return
            }
            pipe.name = pipeName
            targetNode.addChild(pipe)
            
            let moveAction = SKAction.move(to: CGPoint(x: -(pipe.size.width + scene.size.width), y: pipe.position.y), duration: pipeMoveDuration)
            let sequence = SKAction.sequence([moveAction, cleanUpAction])
            pipe.run(sequence)
        }
        
        let sequce = SKAction.sequence([waitAction, producePipeAction])
        return SKAction.repeatForever(sequce)
    }
    
    
    static func produceStandardPipe(sceneSize: CGSize) -> SKSpriteNode? {
        guard let pipeParts = PipeFactory.standardPipeParts(for: sceneSize) else {
            debugPrint(#function + " could not unwrap PipeParts type since it's nil")
            return nil
        }
        
        let pipeNode = SKSpriteNode(texture: nil, color: .clear, size: pipeParts.top.size)
        pipeNode.addChild(pipeParts.top)
        pipeNode.addChild(pipeParts.threshold)
        pipeNode.addChild(pipeParts.bottom)
        
        return pipeNode
    }
    
    
    // MARK: - Pipe parts production
    
    private static func standardPipeParts(for sceneSize: CGSize) -> PipeParts? {
        
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
        
        return PipeParts(top: unwrappedPipeTop, bottom: unwrappedPipeBottom, threshold: threshold)
    }

}
