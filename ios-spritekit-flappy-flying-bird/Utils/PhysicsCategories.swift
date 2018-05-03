//
//  PhysicsCategories.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

/// Defines a set of physics categories for in-game physics-enabled objects
struct PhysicsCategories : OptionSet {
    let rawValue : UInt32
    
    static let boundary     = PhysicsCategories(rawValue: 1 << 0)
    static let player       = PhysicsCategories(rawValue: 1 << 1)
    static let pipe         = PhysicsCategories(rawValue: 1 << 2)
    static let gap          = PhysicsCategories(rawValue: 1 << 3)
}
