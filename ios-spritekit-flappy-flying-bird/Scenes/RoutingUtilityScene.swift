//
//  RoutingUtilityScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 12/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class RoutingUtilityScene: SKScene, ButtonNodeResponderType {
    
    // MARK: - Properties
    
    let selection = UISelectionFeedbackGenerator()
    static let sceneScaleMode: SKSceneScaleMode = .aspectFit
    private static var lastPushTransitionDirection: SKTransitionDirection?
    
    
    // MARK: - Conformance to ButtonNodeResponderType
    
    func buttonTriggered(button: ButtonNode) {
        debugPrint(#function + " button was triggered with identifier of : ", button.buttonIdentifier)
        
        guard let identifier = button.buttonIdentifier else {
            return
        }
        selection.selectionChanged()
        
        switch identifier {
        case .play:
            guard let gameScene = GameScene(fileNamed: "GameScene") else {
                return
            }
            gameScene.scaleMode = RoutingUtilityScene.sceneScaleMode
            self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
        case .settings:
            guard let settingsScene = SettingsScene(fileNamed: "SettingsScene") else {
                return
            }
            RoutingUtilityScene.lastPushTransitionDirection = .down
            settingsScene.scaleMode = RoutingUtilityScene.sceneScaleMode
            self.view?.presentScene(settingsScene, transition: SKTransition.push(with: .down, duration: 1.0))
            
        case .scores:
            guard let scoresScene = ScoresScene(fileNamed: "ScoreScene") else {
                return
            }
            RoutingUtilityScene.lastPushTransitionDirection = .up
            scoresScene.scaleMode = RoutingUtilityScene.sceneScaleMode
            self.view?.presentScene(scoresScene, transition: SKTransition.push(with: .up, duration: 1.0))
            
        case .menu:
            guard let titleScene = TitleScene(fileNamed: "TitleScene") else {
                return
            }
            titleScene.scaleMode = RoutingUtilityScene.sceneScaleMode
            
            var pushDirection: SKTransitionDirection?
            
            if let lastPushTransitionDirection = RoutingUtilityScene.lastPushTransitionDirection {
                switch lastPushTransitionDirection {
                case .up:
                    pushDirection = .down
                case .down:
                    pushDirection = .up
                case .left:
                    pushDirection = .right
                case .right:
                    pushDirection = .left
                }
                RoutingUtilityScene.lastPushTransitionDirection = pushDirection
            }
            if let pushDirection = pushDirection {
                
                self.view?.presentScene(titleScene, transition: SKTransition.push(with: pushDirection, duration: 1.0))
            } else {
                self.view?.presentScene(titleScene, transition: SKTransition.fade(withDuration: 1.0))
            }
        default:
            debugPrint(#function + "triggered button node action that is not supported by the TitleScene class")
        }
    }
}
