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
        launchPipeFactory(for: scene)
    }
    
    // MARK: - Lifecycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Tell the bird that it needs to be resting until the user taps on a screen
        adapter.bird?.isAffectedByGravity = false
        // Start procuding the pipes as soon as the state was entered
        adapter.scene?.run(infinitePipeProducer, withKey: infinitePipeProducerKey)
        
        // Change the audio song to the game scene theme
        adapter.scene?.addChild(adapter.playingAudio)
        SKAction.play()
        
        // Do nothing is the previous state was PausedState since we don't want to reset the bird's position and manu audio
        if previousState is PausedState {
            return
        }
        
        // Otherwise check the adapter and the bird
        guard let scene = adapter.scene, let bird = adapter.bird else {
            return
        }
        // If everything is allright then continue setting up the state
        
        // Remove the menu audio when the game is restarted
        if let menuAudio = scene.childNode(withName: adapter.menuAudio.name!) {
            menuAudio.removeFromParent()
        }
        
        // Initial posiion of the Bird
        bird.position = CGPoint(x: bird.size.width / 2 + 24, y: scene.size.height / 2)
        bird.zPosition = 10
        bird.shouldUpdate = true
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        adapter.playingAudio.removeFromParent()
        adapter.scene?.removeAction(forKey: infinitePipeProducerKey)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    // MARK: - Methods
    
    private func preparePlayer(for scene: SKScene) {
        adapter.bird = BirdNode(animationTimeInterval: 0.1, withTextureAtlas: adapter.playerResourceName, size: adapter.playerSize)
        guard let bird = adapter.bird else {
            debugPrint(#function + " could, not unwrap BirdNode, the execution will be aborted")
            return
        }
        bird.position = CGPoint(x: bird.size.width / 2 + 24, y: scene.size.height / 2)
        bird.zPosition = 10
        
        scene.addChild(bird)
        
        adapter.updatables.append(bird)
        adapter.touchables.append(bird)
    }
    
    private func launchPipeFactory(for scene: SKScene) {
        
        let topPipeName = "top-pipe"
        let bottomPipeName = "bottom-pipe"
        let thresholdPipeName = "threshold-pipe"
        
        let cleanUpBottomPipeAction = SKAction.run { [weak self] in
            self?.adapter.infiniteBackgroundNode?.childNode(withName: bottomPipeName)?.removeFromParent()
            
        }
        let cleanUpTopPipeAction = SKAction.run { [weak self] in
            self?.adapter.infiniteBackgroundNode?.childNode(withName: topPipeName)?.removeFromParent()
        }
        let cleanUpThresholdPipeAction = SKAction.run { [weak self] in
            self?.adapter.infiniteBackgroundNode?.childNode(withName: thresholdPipeName)?.removeFromParent()
        }
        
        let waitAction = SKAction.wait(forDuration: 3.0)
        
        let pipeMoveDuration: TimeInterval = 4.0
        
        let producePipeAction = SKAction.run { [weak self] in
            
            guard let pipes = PipeFactory.produce(sceneSize: scene.size) else {
                return
            }
            let scrollingNode = self?.adapter.infiniteBackgroundNode
            pipes.bottom.name = bottomPipeName
            pipes.top.name = topPipeName
            pipes.threshold.name = thresholdPipeName
            
            scrollingNode?.addChild(pipes.top)
            scrollingNode?.addChild(pipes.bottom)
            scrollingNode?.addChild(pipes.threshold)
            
            // Construct move actions for pipes
            let bottom = pipes.bottom
            let top = pipes.top
            let threshold = pipes.threshold
            
            let pipeBottomMoveAction = SKAction.move(to: CGPoint(x: -bottom.size.width, y: bottom.position.y), duration: pipeMoveDuration)
            let pipeTopMoveAction = SKAction.move(to: CGPoint(x: -top.size.width, y: top.position.y), duration: pipeMoveDuration)
            let pipeThresholdMoveAction = SKAction.move(to: CGPoint(x: -threshold.size.width, y: threshold.position.y), duration: pipeMoveDuration - 0.4)
            
            let pipeBottomMoveSequence = SKAction.sequence([pipeBottomMoveAction, cleanUpBottomPipeAction])
            let pipeTopMoveSequence = SKAction.sequence([pipeTopMoveAction, cleanUpTopPipeAction])
            let pipeThresholdMoveSequence = SKAction.sequence([pipeThresholdMoveAction, cleanUpThresholdPipeAction])
            
            bottom.run(pipeBottomMoveSequence)
            top.run(pipeTopMoveSequence)
            threshold.run(pipeThresholdMoveSequence)
        }
        
        let sequenceAction = SKAction.sequence([waitAction, producePipeAction])
        infinitePipeProducer = SKAction.repeatForever(sequenceAction)
        
    }
}

