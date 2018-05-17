//
//  LoopedBgrndNode.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit
import SpriteKit

class InfiniteSpriteScrollNode: SKNode {
    
    var shouldUpdate: Bool = true
    
    // MARK: - Constants
    
    let key = "background"
    
    // MARK: - Properties
    
    var tiles: [SKNode]
    var background: SKNode
    var backgroundSpeed: TimeInterval
    
    let maxNumOfTiles = 2
    
    internal var delta = TimeInterval(0)
    internal var lastUpdateTime = TimeInterval(0)
    
    // MARK: - Initailziers
    
    init(fileName: String, scaleFactor scale: CGPoint = CGPoint(x: 1.0, y: 1.0), speed: TimeInterval = 100) {
        self.backgroundSpeed = speed
        
        let yShift: CGFloat = 5.0
        
        tiles = [SKSpriteNode]()
        background = SKNode()
        let texture = SKTexture(imageNamed: fileName)
        let width = texture.size().width
        
        
        for x in 0...maxNumOfTiles {
            let tile = SKSpriteNode(texture: texture)
            tile.xScale = scale.x
            tile.yScale = scale.y
            tile.anchorPoint = .zero

            tile.position = CGPoint(x: CGFloat(x) * width * scale.x, y: yShift)
            tile.name = key
            tile.zPosition = 0
            background.addChild(tile)
        }
        
        super.init()
        
        background.enumerateChildNodes(withName: key) { [weak self] node, pointer in
            self?.tiles += [node]
        }
        
        self.addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    fileprivate func moveBackground() {
        let posX = -backgroundSpeed * delta
        background.position = CGPoint(x: background.position.x + CGFloat(posX), y: 0.0)
        
        let maxTiles = CGFloat(maxNumOfTiles)
        
        background.enumerateChildNodes(withName: key) { [weak self] node, stop in
            if let unwrappedSelf = self {
                let background_screen_position = unwrappedSelf.background.convert(node.position, to: unwrappedSelf)
                
                if background_screen_position.x <= -node.frame.size.width {
                    node.position = CGPoint(x: node.position.x + (node.frame.size.width * maxTiles), y: node.position.y)
                }
            } else {
                debugPrint(#function + " could not unwrap self, current enumeration iteration will be skipped")
                
            }
        }
    }
    
    
}

// MARK: - Extension that adds support for Updatable protocol
extension InfiniteSpriteScrollNode: Updatable {
    
    // MARK: - Conformance to the Updtable protocol

    func update(_ currentTime: TimeInterval) {
        let computedUpdatable = computeUpdatable(currentTime: currentTime)
        delta = computedUpdatable.delta
        lastUpdateTime = computedUpdatable.lastUpdateTime
        
        moveBackground()
    }
}
