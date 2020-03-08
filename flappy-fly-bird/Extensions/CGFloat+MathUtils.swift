//
//  Float+MathUtils.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    
    // MARK: - Properties
    
    var toRadians: CGFloat {
        return CGFloat.pi * self / 180
    }
    
    // MARK: - Methods
    
    func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        if (self > max) {
            return max
        } else if (self < min) {
            return min
        } else {
            return self
        }
    }
    
    static func range(min: CGFloat, max: CGFloat) -> CGFloat {
        CGFloat.random(in: min...max)
    }
}
