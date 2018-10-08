//
//  SettingsScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 12/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class SettingsScene: RoutingUtilityScene, ToggleButtonNodeResponderType, TriggleButtonNodeResponderType {

    // MARK: - Overrides
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let soundButton = scene?.childNode(withName: "Sound") as? ToggleButtonNode
        soundButton?.isOn = UserDefaults.standard.bool(for: .isSoundOn)
        
        let difficultyButton = scene?.childNode(withName: "Difficulty") as? TriggleButtonNode
        let difficultyLevel = UserDefaults.standard.getDifficultyLevel()
        let difficultyState = TriggleButtonNode.TriggleState.convert(from: difficultyLevel)
        difficultyButton?.triggle = .init(state: difficultyState)
    }
    
    // MARK: - Confrormance to ToggleButtonResponderType
    
    func toggleButtonTriggered(toggle: ToggleButtonNode) {
        UserDefaults.standard.set(toggle.isOn, for: .isSoundOn)
    }
    
    // MARK: - Conformance to TriggleButtonResponderType
    
    func triggleButtonTriggered(triggle: TriggleButtonNode) {
        debugPrint("triggleButtonTriggered")
        let diffuculty = triggle.triggle.toDifficultyLevel()
        UserDefaults.standard.set(difficultyLevel: diffuculty)
    }
    
}
