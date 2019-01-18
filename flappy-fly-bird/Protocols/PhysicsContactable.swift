//
//  PhysicsContactable.swift
//  flappy-fly-bird
//
//  Created by Astemir Eleev on 18/01/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import SpriteKit

/// Allows to quickly enable/disable collision detection for physics-enabled conformances
protocol PhysicsContactable {
    var shouldEnablePhysics: Bool { get set }
    var collisionBitMask: UInt32 { get }
}
