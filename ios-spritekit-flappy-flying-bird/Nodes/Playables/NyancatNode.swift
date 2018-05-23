//
//  NyancatNode.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 20/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

// TODO: Needs to be refactored
class NyancatNode: SKSpriteNode, Updatable {
    
    // MARK: - Conformance to Updatable protocol
    
    var delta: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var shouldUpdate: Bool = true {
        didSet {
//            if shouldUpdate {
//                animate(with: animationTimeInterval)
//
//            } else {
//                self.removeAllActions()
//            }
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
    
    private let impact = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Initializers
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.xScale = 0.2
        self.yScale = 0.2
        
        commonInit()
        preparePhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.xScale = 0.2
        self.yScale = 0.2
        
        commonInit()
        preparePhysicsBody()
    }
    
    // MAKR: - Utils
    
    private func commonInit() {
        let midPoint = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        
        // Create the cat sprite node
        let nyanCat = SKSpriteNode(imageNamed: "Nyancat")
        nyanCat.position = midPoint
        nyanCat.setScale(10.0)
        nyanCat.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: 0, y: 100, duration: 0.15),
            SKAction.moveBy(x: 0, y: -100, duration: 0.15)
            ])))
        nyanCat.zPosition = 10
        self.addChild(nyanCat)

        // Star dust particle system
        // TODO: needs to be refactored
//        let emitter = SKEmitterNode()
//        emitter.particleLifetime = 40
//        emitter.particleBlendMode = SKBlendMode.alpha
//        emitter.particleBirthRate = 3
//        emitter.particleSize = CGSize(width: 4,height: 4)
//        emitter.particleColor = SKColor(red: 100, green: 100, blue: 255, alpha: 1)
//        emitter.position = CGPoint(x:frame.size.width,y:midPoint.y)
//        emitter.particleSpeed = 16
//        emitter.particleSpeedRange = 100
//        emitter.particlePositionRange = CGVector(dx: 0, dy: frame.size.height)
//        emitter.emissionAngle = 3.14
//        emitter.advanceSimulationTime(40)
//        emitter.particleAlpha = 0.5
//        emitter.particleAlphaRange = 0.5
//        self.addChild(emitter)
        
        
        class RainbowParticle : SKEmitterNode {
            init(childOf:SKNode,target:SKNode, color:SKColor, position:CGPoint){
                super.init()
                self.particleLifetime = 10
                self.particleBlendMode = SKBlendMode.alpha
                self.particleBirthRate = 80
                self.particleSpeed = 100
                self.emissionAngle = 3.14151692
                self.targetNode = target
                self.particleSize = CGSize(width: 6, height: 6)
                self.particleColor = color
                self.position = position
                childOf.addChild(self)
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        
        let rainbowColors = [
            SKColor(red: 255/255, green: 43/255, blue: 14/255, alpha: 1),
            SKColor(red: 255/255, green: 168/255, blue: 6/255, alpha: 1),
            SKColor(red: 255/255, green: 244/255, blue: 5/255, alpha: 1),
            SKColor(red: 51/255, green: 234/255, blue: 5/255, alpha: 1),
            SKColor(red: 8/255, green: 163/255, blue: 255/255, alpha: 1),
            SKColor(red: 8122255, green: 85/255, blue: 255/255, alpha: 1)
        ]
        
        var yMultiplier : CGFloat = 0.5
        for rainbowColor in rainbowColors {
            let emitter = RainbowParticle(
                childOf: self,
                target: nyanCat,
                color: rainbowColor,
                position:
                CGPoint(
                    x: nyanCat.calculateAccumulatedFrame().width * -0.32 + nyanCat.position.x,
                    y: nyanCat.calculateAccumulatedFrame().height * yMultiplier + nyanCat.position.y
                )
            )
            emitter.zPosition = 10
            yMultiplier -= 0.15
        }
        
    }
    
    
    fileprivate func preparePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.5)
//        let texture = SKTexture(imageNamed: "Nyancat")
//        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
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
            self.physicsBody?.velocity = CGVector(dx: velocityX, dy: threshold)
        }
        
        let velocityValue = velocityY * (velocityY < 0 ? 0.003 : 0.001)
        zRotation = velocityValue.clamp(min: -1, max: 1.0)
    }
    
}


extension NyancatNode: Touchable {
    // MARK: - Conformance to Touchable protocol
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !shouldAcceptTouches { return }
        
        impact.impactOccurred()
        
        isAffectedByGravity = true
        // Apply an impulse to the DY value of the physics body of the bird
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
    }
}


