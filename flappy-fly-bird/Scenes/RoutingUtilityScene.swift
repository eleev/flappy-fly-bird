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
    static let sceneScaleMode: SKSceneScaleMode = .aspectFill
    private static var lastPushTransitionDirection: SKTransitionDirection?
    
    
    // MARK: - Conformance to ButtonNodeResponderType
    
    func buttonTriggered(button: ButtonNode) {
        guard let identifier = button.buttonIdentifier else {
            return
        }
        selection.selectionChanged()
    
        var sceneToPresent: SKScene?
        var transition: SKTransition?
        let sceneScaleMode: SKSceneScaleMode = RoutingUtilityScene.sceneScaleMode
        
        switch identifier {
        case .play:
            let sceneId = Scenes.game.getName()
            sceneToPresent = GameScene(fileNamed: sceneId)
            
            transition = SKTransition.fade(withDuration: 1.0)
        case .settings:
            let sceneId = Scenes.setting.getName()
            sceneToPresent = SettingsScene(fileNamed: sceneId)
            
            RoutingUtilityScene.lastPushTransitionDirection = .down
            transition = SKTransition.push(with: .down, duration: 1.0)
        case .scores:
            let sceneId = Scenes.score.getName()
            sceneToPresent = ScoresScene(fileNamed: sceneId)
            
            RoutingUtilityScene.lastPushTransitionDirection = .up
            transition = SKTransition.push(with: .up, duration: 1.0)
            
        case .characters:
            let sceneId = Scenes.characters.getName()
            sceneToPresent = CharactersScene(fileNamed: sceneId)
            debugPrint("created CharactersScene instance")
            
            RoutingUtilityScene.lastPushTransitionDirection = .right
            transition = SKTransition.push(with: .right, duration: 1.0)
        case .menu:
            let sceneId = Scenes.title.getName()
            sceneToPresent = TitleScene(fileNamed: sceneId)
            
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
                @unknown default:
                    fatalError("Unknown case was deteced in .menu case in buttonTriggered method. Please, make sure that all the cases are properly handled.")
                }
                RoutingUtilityScene.lastPushTransitionDirection = pushDirection
            }
            if let pushDirection = pushDirection {
                transition = SKTransition.push(with: pushDirection, duration: 1.0)
            } else {
                transition = SKTransition.fade(withDuration: 1.0)
            }
        default:
            debugPrint(#function + "triggered button node action that is not supported by the TitleScene class")
        }
        
        guard let presentationScene = sceneToPresent, let unwrappedTransition = transition  else {
            return
        }
        
        presentationScene.scaleMode = sceneScaleMode
        unwrappedTransition.pausesIncomingScene = false
        unwrappedTransition.pausesOutgoingScene = false
        self.view?.presentScene(presentationScene, transition: unwrappedTransition)
        debugPrint("presented CharactersScene instance")
    }
}
