//
//  GameSceneProtocol.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 03/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import SpriteKit

/// Declares a contract that each game scene (SKScene class) should conform to. SKNodes should conform to one of the protocol (Updatable, Touchable etc.) and be inserted into the corresponding arrays.
protocol GameSceneProtocol {
    
    // MARK: - Properties
    
    /// Please note that you need to mark this property as weak or unowned in the structures/classes that conform to this procool
    var scene: SKScene? { get }
    
    var updatables: [Updatable] { get }
    var touchables: [Touchable] { get }
    
    // MARK: - Initializers
    
    init?(with scene: SKScene)
    
}
