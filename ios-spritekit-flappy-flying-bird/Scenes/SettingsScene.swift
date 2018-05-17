//
//  SettingsScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 12/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class SettingsScene: RoutingUtilityScene, ToggleButtonNodeResponderType {

    // MARK: - Overrides
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let soundButton = scene?.childNode(withName: "Sound") as? ToggleButtonNode
        soundButton?.isOn = UserDefaults.standard.bool(for: .isSoundOn)
    }
    
    // MARK: - Confrormance to ToggleButtonResponderType
    
    func toggleButtonTriggered(toggle: ToggleButtonNode) {
        UserDefaults.standard.set(toggle.isOn, for: .isSoundOn)
    }
}
