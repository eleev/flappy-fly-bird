//
//  ScoresScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 12/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class ScoresScene: RoutingUtilityScene {
    
    // MARK: - Overrides
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        fetchScores()
        advanceRainParticleEmitter(for: 10)
    }
    
    // MARK: - Helpers
    
    private func advanceRainParticleEmitter(for amount: TimeInterval) {
        let particleEmitter = childNode(withName: "Rain Particle Emitter") as? SKEmitterNode
        particleEmitter?.advanceSimulationTime(amount)
    }
    
    private func fetchScores() {
        // Read the scores from UserDefaults
        
        if let bestScoreLabel = self.scene?.childNode(withName: "Best Score Label") as? SKLabelNode {
            let bestScore = UserDefaults.standard.integer(for: .bestScore)
            bestScoreLabel.text = "Best: \(bestScore)"
        }
        
        if let lastScoreLabel = self.scene?.childNode(withName: "Last Score Label") as? SKLabelNode {
            let lastScore = UserDefaults.standard.integer(for: .lastScore)
            lastScoreLabel.text = "Last: \(lastScore)"
        }
    }
}
