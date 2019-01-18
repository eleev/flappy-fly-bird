//
//  GameOverState.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 05/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameOverState: GKState {
    
    // MARK: - Properites
    
    var overlaySceneFileName: String {
        return Scenes.failed.getName()
    }
    
    unowned var levelScene: GameSceneAdapter
    var overlay: SceneOverlay!
    
    // MARK: - Utility Properties
    
    private(set) var currentScoreLabel: SKLabelNode?
    
    // MARK: - Intializers
    
    init(scene: GameSceneAdapter) {
        self.levelScene = scene
        super.init()
     
        overlay = SceneOverlay(overlaySceneFileName: overlaySceneFileName, zPosition: 100)
        currentScoreLabel = overlay.contentNode.childNode(withName: "Current Score") as? SKLabelNode
    }
   
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        if previousState is PlayingState {
            // Clean up the pipes from the previous run
            levelScene.removePipes()
        }
        
        // Disable interaction with the bird
        levelScene.playerCharacter?.shouldAcceptTouches = false
        
        // Update the scores
        updateScores()
        
        // Update the score label
        updasteOverlayPresentation()
        
        // Hide the overlay and the game scene HUD
        levelScene.overlay = overlay
        levelScene.isHUDHidden = true
        
        // Stop any updates
        levelScene.playerCharacter?.shouldUpdate = false
        
        // Remove all actions related to the scene, including the generation of new pipes
        levelScene.scene?.removeAllActions()
        
        // Reset the number of scores
        levelScene.score = 0
        
        if levelScene.isSoundOn {
            // Find a playing audio node and remove it
            if let playingAudioNodeName = levelScene.playingAudio.name {
                levelScene.scene?.childNode(withName: playingAudioNodeName)?.removeFromParent()
            }
            // Add a manu audio node and start playing it
            if levelScene.scene?.childNode(withName: levelScene.menuAudio.name!) == nil {
                levelScene.scene?.addChild(levelScene.menuAudio)
                SKAction.play()
            }
        }
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        // Only remove the overlay scene when the next state is Playing state
        if nextState is PlayingState {
            // Remove the overlay node
            levelScene.overlay = nil
            // Reveal the game scene HUD
            levelScene.isHUDHidden = false
            // Enable the interactions with the bird
            levelScene.playerCharacter?.shouldAcceptTouches = true
            
            // Removes the player form the scene, just right before launching the PlayingState. This is experimental, and should be removed once the current version will be validated on stability
//            levelScene.playerCharacter?.shouldEnablePhysics = true
//            levelScene.playerCharacter?.removeFromParent()
        }
    }
    
    // MARK: Convenience
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
}

extension GameOverState {
    
    fileprivate func updateScores() {
        let bestScore = UserDefaults.standard.integer(for: .bestScore)
        let currentScore = levelScene.score
        
        if currentScore > bestScore {
            // Update the best score
            UserDefaults.standard.set(currentScore, for: .bestScore)
        }
        UserDefaults.standard.set(currentScore, for: .lastScore)
    }
    
    fileprivate func updasteOverlayPresentation() {
        let contentNode = overlay.contentNode
        
        if let bestScoreLabel = contentNode.childNode(withName: "Best Score") as? SKLabelNode {
            let bestScore = UserDefaults.standard.integer(for: .bestScore)
            bestScoreLabel.text = "Best Score: \(bestScore)"
        }
        
        if let currentScore = contentNode.childNode(withName: "Current Score") as? SKLabelNode {
            currentScore.text = "Current Score: \(levelScene.score)"
        }
    }
}
