//
//  PlayingState.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 05/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayingState: GKState {
    
    // MARK: - Properites
    
    unowned var adapter: GameSceneAdapter

    private(set) var infinitePipeProducer: SKAction! = nil
    let infinitePipeProducerKey = "Pipe Action"
    
    // MARK: - Intializers
    
    init(adapter: GameSceneAdapter) {
        self.adapter = adapter
        super.init()
        
        guard let scene = adapter.scene else {
            return
        }
        preparePlayer(for: scene)
        
        if let scene = adapter.scene, let target = adapter.infiniteBackgroundNode {
            infinitePipeProducer = PipeFactory.launch(for: scene, targetNode: target)
        }
        
        adapter.advanceSnowEmitter(for: 15)
    }
    
    // MARK: - Lifecycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Tell the bird that it needs to be resting until the user taps on a screen
        adapter.playerCharacter?.isAffectedByGravity = false
        // Start procuding the pipes as soon as the state was entered
        adapter.scene?.run(infinitePipeProducer, withKey: infinitePipeProducerKey)
        
        if adapter.isSoundOn {
            // Change the audio song to the game scene theme
            adapter.scene?.addChild(adapter.playingAudio)
            SKAction.play()
        }
        
        // Do nothing is the previous state was PausedState since we don't want to reset the bird's position and manu audio
        if previousState is PausedState {
            return
        }
        
        // Otherwise check the adapter and the bird
        guard let scene = adapter.scene, let player = adapter.playerCharacter else {
            return
        }
        // If everything is allright then continue setting up the state
        
        
        if adapter.isSoundOn {
            // Remove the menu audio when the game is restarted
            if let menuAudio = scene.childNode(withName: adapter.menuAudio.name!) {
                menuAudio.removeFromParent()
            }
        }
        
        // Initial posiion of the Player
        
        let character = UserDefaults.standard.playableCharacter(for: .character) ?? .bird
        position(player: character, in: scene)
        player.shouldUpdate = true
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        if adapter.isSoundOn {
            adapter.playingAudio.removeFromParent()
            adapter.scene?.removeAction(forKey: infinitePipeProducerKey)
        }

        if nextState is GameOverState {
            // Clean up the pipes from the previous run
            adapter.removePipes()

            // Reset the score label
            adapter.resetScores()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    // MARK: - Methods
    
    private func preparePlayer(for scene: SKScene) {
        let character = UserDefaults.standard.playableCharacter(for: .character) ?? .bird
        let assetName = character.getAssetName()
        
        switch character {
        case .bird:
            adapter.playerCharacter = BirdNode(animationTimeInterval: 0.1, withTextureAtlas: assetName, size: adapter.playerSize)
        case .coinCat, .gamecat, .hipCat, .jazzCat, .lifelopeCat:
            let player = NyancatNode(animatedGif: assetName, correctAspectRatioFor: adapter.playerSize.width)
            player.xScale = 0.4
            player.yScale = 0.4
            adapter.playerCharacter = player
        }
        
        guard let playableCharacter = adapter.playerCharacter else {
            debugPrint(#function + " could, not unwrap BirdNode, the execution will be aborted")
            return
        }
        position(player: character, in: scene)
        scene.addChild(playableCharacter)
        
        adapter.updatables.append(playableCharacter)
        adapter.touchables.append(playableCharacter)
    }
    
    private func position(player: PlayableCharacter, in scene: SKScene) {
        guard let playerNode = adapter.playerCharacter else {
            return
        }
        
        switch player {
        case .bird:
            playerNode.position = CGPoint(x: playerNode.size.width / 2 + 50, y: scene.size.height / 2)
        case .coinCat, .gamecat, .hipCat, .jazzCat, .lifelopeCat:
            playerNode.position = CGPoint(x: (playerNode.size.width / 2) - 20, y: scene.size.height / 2)
        }
        playerNode.zPosition = 10

    }
   
}
