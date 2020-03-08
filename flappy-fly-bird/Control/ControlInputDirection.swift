//
//  ControlInput.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 07/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import simd

enum ControlInputDirection: Int {
    case up = 0, down, left, right
    
    init?(vector: SIMD2<Float>) {
        // Require sufficient displacement to specify direction.
        guard length(vector) >= 0.5 else { return nil }
        
        // Take the max displacement as the specified axis.
        if abs(vector.x) > abs(vector.y) {
            self = vector.x > 0 ? .right : .left
        } else {
            self = vector.y > 0 ? .up : .down
        }
    }
}
