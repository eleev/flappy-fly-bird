//
//  NyancatNode.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 20/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class NyancatRainbowNode: SKSpriteNode, Updatable, Playable {
    
    // MARK: - Conformance to Updatable protocol
    
    var delta: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var shouldUpdate: Bool = true {
        didSet {
            if shouldUpdate {
                prepareRainbowEffect()
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
    
    override var position: CGPoint {
        didSet {
            var yMultiplier : CGFloat = 0.5

            rainbowParticles.forEach { particle in
                let position = CGPoint(x: self.calculateAccumulatedFrame().width * -0.32 + self.position.x,
                y: self.calculateAccumulatedFrame().height * yMultiplier + self.position.y)
                particle.position = position
                
                yMultiplier -= 0.15
            }
        }
    }
    
    private let impact = UIImpactFeedbackGenerator(style: .medium)
    private weak var parentScene: SKScene?
    private var rainbowParticles: [RainbowParticle] = []
    
    class RainbowParticle: SKEmitterNode {
        
        // MARK: - Initailzier
        
        init(childOf: SKNode, target: SKNode, color: SKColor, position: CGPoint) {
            super.init()
            
            particleLifetime = 10
            particleBlendMode = SKBlendMode.alpha
            particleBirthRate = 100
            particleSpeed = 150
            emissionAngle = 3.141516
            targetNode = target
            particleSize = CGSize(width: 10, height: 10)
            particleColor = color
            self.position = position
            
            childOf.addChild(self)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    // MARK: - Initializers
    
    init(size: CGSize, parentScene: SKScene) {
        super.init(texture: nil, color: .clear, size: size)
        
        self.parentScene = parentScene
        
        commonInit()
        preparePhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Remove the texture that was set in the editor, so there are no visual issues during the runtime
        self.texture = nil
        self.color = .clear
        
        commonInit()
        preparePhysicsBody()
    }
    
    // MAKR: - Utils
    
    private func commonInit() {
        self.texture = SKTexture(imageNamed: "Nyancat")
        name = "nyancatAnim"
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: 0, y: 20, duration: 0.15),
            SKAction.moveBy(x: 0, y: -20, duration: 0.15)
            ])))
        zPosition = 10
        
        prepareRainbowEffect()
    }
    
    private func prepareRainbowEffect() {
        
        // Rainbow colors
        
        let rainbowColors = [
            SKColor(red: 255/255, green: 43/255, blue: 14/255, alpha: 1),
            SKColor(red: 255/255, green: 168/255, blue: 6/255, alpha: 1),
            SKColor(red: 255/255, green: 244/255, blue: 5/255, alpha: 1),
            SKColor(red: 51/255, green: 234/255, blue: 5/255, alpha: 1),
            SKColor(red: 8/255, green: 163/255, blue: 255/255, alpha: 1),
            SKColor(red: 225/255, green: 85/255, blue: 255/255, alpha: 1)
        ]
        
        guard let parentScene = parentScene else {
            return
        }
        
        var yMultiplier : CGFloat = 0.5
        for (index, rainbowColor) in rainbowColors.enumerated() {
            
            let emitter = RainbowParticle(
                childOf: parentScene,
                target: self,
                color: rainbowColor,
                position:
                CGPoint(
                    x: self.calculateAccumulatedFrame().width * -0.32 + self.position.x,
                    y: self.calculateAccumulatedFrame().height * yMultiplier + self.position.y
                )
            )
            emitter.name = "emitter-\(index)"
            emitter.zPosition = self.zPosition - 1
            yMultiplier -= 0.15
            
            rainbowParticles += [emitter]
        }
    }
    
    
    fileprivate func preparePhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        
        physicsBody?.categoryBitMask = PhysicsCategories.player.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategories.pipe.rawValue | PhysicsCategories.gap.rawValue | PhysicsCategories.boundary.rawValue
        physicsBody?.collisionBitMask = PhysicsCategories.pipe.rawValue | PhysicsCategories.boundary.rawValue
        
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0.0
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
        zRotation = velocityValue.clamp(min: -1, max: 1.5)
    }
    
}


extension NyancatRainbowNode: Touchable {
    // MARK: - Conformance to Touchable protocol
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !shouldAcceptTouches { return }
        
        impact.impactOccurred()
        
        isAffectedByGravity = true
        // Apply an impulse to the DY value of the physics body of the bird
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
    }
}




