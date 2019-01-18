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
    
    private let playerScale = CGPoint(x: 0.4, y: 0.4)
    private let snowEmitterAdvancementInSeconds: TimeInterval = 15
    private let animationTimeInterval: TimeInterval = 0.1
    
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
        
        adapter.advanceSnowEmitter(for: snowEmitterAdvancementInSeconds)
    }
    
    // MARK: - Lifecycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // If previous state is GameOver or nil (which is the default state, when the game is launched), we then check whether the adaper's scene is not nil and the we instantiate a new player character.
        //
        // Otherwise, we do nothing, since we were in the PausedState, and all we have to do is to resume the game
//        if let scene = adapter.scene, previousState is GameOverState || previousState == nil {
//            preparePlayer(for: scene)
//        }
        
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
        }

        if nextState is GameOverState {
            adapter.scene?.removeAction(forKey: infinitePipeProducerKey)

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
            adapter.playerCharacter = BirdNode(
                animationTimeInterval: animationTimeInterval,
                withTextureAtlas: assetName,
                size: adapter.playerSize)
        case .coinCat, .gamecat, .hipCat, .jazzCat, .lifelopeCat:
            let player = NyancatNode(
                animatedGif: assetName,
                correctAspectRatioFor: adapter.playerSize.width)
            player.xScale = playerScale.x
            player.yScale = playerScale.y
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
