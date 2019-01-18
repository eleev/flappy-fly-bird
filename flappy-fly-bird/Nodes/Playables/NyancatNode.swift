//
//  NyancatNode.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 28/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit
import Foundation

class NyancatNode: SKNode, Updatable, Playable, PhysicsContactable {
    
    // MARK: - Conformance to Updatable, Playable & PhysicsContactable protocols

    var size: CGSize
    
    // MARK: - Conformance to Updatable protocol
    
    var delta: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var shouldUpdate: Bool = true
    
    var isAffectedByGravity: Bool = true {
        didSet {
            physicsBody?.affectedByGravity = isAffectedByGravity
        }
    }
    
    var shouldAcceptTouches: Bool = true {
        didSet {
            self.isUserInteractionEnabled = shouldAcceptTouches
        }
    }

    var shouldEnablePhysics: Bool = true {
        didSet {
            // Set the specified collision bit mask or 0 which basically disables all the collision testing
            physicsBody?.collisionBitMask = shouldEnablePhysics ? collisionBitMask : 0
        }
    }
    
    var collisionBitMask: UInt32 = PhysicsCategories.pipe.rawValue | PhysicsCategories.boundary.rawValue

    // MARK: - Private properties
    
    private let impact = UIImpactFeedbackGenerator(style: .medium)
    private var animatedGifNode: SKSpriteNode
    
    // MARK: - Initialisers
    
    init(animatedGif name: String, correctAspectRatioFor width: CGFloat) {
        animatedGifNode = SKSpriteNode(withAnimatedGif: name, correctAspectRatioFor: width)
        size = animatedGifNode.size
        
        super.init()
        
        preparePlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        size = .zero
        animatedGifNode = SKSpriteNode(texture: nil, color: .clear, size: .zero)
        
        super.init(coder: aDecoder)
        
        guard let assetName = userData!["assetName"] as? String else {
            fatalError(#function + " asset name was not specified")
        }
        animatedGifNode = SKSpriteNode(withAnimatedGif: assetName, correctAspectRatioFor: 100)
        size = animatedGifNode.size
        
        preparePlayer()
    }
    
    // MARK: - Private methods
    
    private func preparePlayer() {
        animatedGifNode.name = self.name
        animatedGifNode.position = .zero
        animatedGifNode.zPosition = 50
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width - 32, height: size.height - 32))
        physicsBody?.categoryBitMask = PhysicsCategories.player.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategories.pipe.rawValue | PhysicsCategories.gap.rawValue | PhysicsCategories.boundary.rawValue
        physicsBody?.collisionBitMask = collisionBitMask
        
        physicsBody?.mass /= 7
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0.0
        
        self.addChild(animatedGifNode)
    }
    
    // MARK: - Conformance to Updatable protocol
    
    func update(_ timeInterval: CFTimeInterval) {
        delta = lastUpdateTime == 0.0 ? 0.0 : timeInterval - lastUpdateTime
        lastUpdateTime = timeInterval
        
        guard let physicsBody = physicsBody else {
            return
        }
        
        let velocityX = physicsBody.velocity.dx
        let velocityY = physicsBody.velocity.dy
        let threshold: CGFloat = 350
        
        if velocityY > threshold {
            physicsBody.velocity = CGVector(dx: velocityX, dy: threshold)
        }
        
        let velocityValue = velocityY * (velocityY < 0 ? 0.004 : 0.002)
        zRotation = velocityValue.clamp(min: -1, max: 1)
    }
    
}


extension NyancatNode: Touchable {
    // MARK: - Conformance to Touchable protocol
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !shouldAcceptTouches { return }
        
        impact.impactOccurred()
        
        isAffectedByGravity = true
        // Apply an impulse to the DY value of the physics body of the bird
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
    }
}
