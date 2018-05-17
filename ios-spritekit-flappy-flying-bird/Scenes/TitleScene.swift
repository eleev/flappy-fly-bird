//
//  TitleScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 06/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class TitleScene: RoutingUtilityScene {
    
    // MARK: - Overrides
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    
        let isSoundOn = UserDefaults.standard.bool(for: .isSoundOn)
        
        if !isSoundOn {
            let audioNode = childNode(withName: "Audio Node") as? SKAudioNode
            audioNode?.isPaused = true
            audioNode?.removeAllActions()
            audioNode?.removeFromParent()
        }
        
    }
}
