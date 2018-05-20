//
//  SKEmitterNode+Utils.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 20/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit.SKEmitterNode

extension SKEmitterNode {
    func safeAdvanceSimulationTime(_ sec: TimeInterval) {
        let emitterPaused = self.isPaused
        
        if emitterPaused {
            self.isPaused = false
        }
        advanceSimulationTime(sec)
        
        if emitterPaused {
            self.isPaused = true
        }
    }
}
