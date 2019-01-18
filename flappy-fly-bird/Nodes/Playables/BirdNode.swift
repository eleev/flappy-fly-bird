//
//  BirdNode.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit
import UIKit

class BirdNode: SKSpriteNode, Updatable, Playable, PhysicsContactable {
    
    // MARK: - Conformance to Playable, Updatable & PhysicsContactable protocols
    
    var delta: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var shouldUpdate: Bool = true {
        didSet {
            if shouldUpdate {
                animate(with: animationTimeInterval)
            } else {
                self.removeAllActions()
            }
        }
    }
    
    var isAffectedByGravity: Bool = true {
        didSet {
            self.physicsBody?.affectedByGravity = isAffectedByGravity
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
    
    // MARK: - Properties
    
    var flyTextures: [SKTexture]? = nil
    private(set) var animationTimeInterval: TimeInterval = 0
    private let impact = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Initializers
    
    convenience init(animationTimeInterval: TimeInterval, withTextureAtlas named: String, size: CGSize) {
        
        var textures = [SKTexture]()
        
        // upload the texture atlas
        do {
            textures = try SKTextureAtlas.upload(named: named, beginIndex: 1) { name, index -> String in
                return "r_player\(index)"
            }
        } catch {
            debugPrint(#function + " thrown the errro while uploading texture atlas : ", error)
        }
        
        self.init(texture: textures.first, color: .clear, size: size)
        self.animationTimeInterval = animationTimeInterval

        preparePhysicsBody()
        
        // attach texture atrlas and prepare animation
        self.flyTextures = textures
        self.texture = textures.first
        self.animate(with: animationTimeInterval)
    }
    
    // MARK: - Methods

    fileprivate func preparePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.5)
        
        physicsBody?.categoryBitMask = PhysicsCategories.player.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategories.pipe.rawValue | PhysicsCategories.gap.rawValue | PhysicsCategories.boundary.rawValue
        physicsBody?.collisionBitMask = PhysicsCategories.pipe.rawValue | PhysicsCategories.boundary.rawValue
        
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0.0
    }
    
    fileprivate func animate(with timing: TimeInterval) {
        guard let walkTextures = flyTextures else {
            return
        }
        
        let animateAction = SKAction.animate(with: walkTextures, timePerFrame: timing, resize: false, restore: true)
        let foreverAction = SKAction.repeatForever(animateAction)
        self.run(foreverAction)
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
            self.physicsBody?.velocity = CGVector(dx: velocityX, dy: threshold)
        }
        
        let velocityValue = velocityY * (velocityY < 0 ? 0.004 : 0.002)
        zRotation = velocityValue.clamp(min: -1, max: 1.0)
    }
    
}

extension BirdNode: Touchable {
    // MARK: - Conformance to Touchable protocol
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !shouldAcceptTouches { return }
        
        impact.impactOccurred()
        
        isAffectedByGravity = true
        // Apply an impulse to the DY value of the physics body of the bird
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
    }
}

