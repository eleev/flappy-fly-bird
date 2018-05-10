//
//  TitleScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 06/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene, ButtonNodeResponderType {
    
    let selection = UISelectionFeedbackGenerator()

    // MARK: - Conformance to ButtonNodeResponderType
    
    func buttonTriggered(button: ButtonNode) {
        guard let identifier = button.buttonIdentifier else {
            return
        }
        selection.selectionChanged()
        
        switch identifier {
        case .play:
            guard let gameScene = GameScene(fileNamed: "GameScene") else {
                return
            }
            gameScene.scaleMode = .aspectFit
            self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
        case .scores:
            debugPrint(#function + " Scores Scene button tapped")
        case .settings:
            debugPrint(#function + " Settings SceneTitle button tapped")
        default:
            debugPrint(#function + "triggered button node action that is not supported by the TitleScene class")
        }
    }
    
    
}
