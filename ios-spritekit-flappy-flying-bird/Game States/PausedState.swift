//
//  PausedState.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 05/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import GameplayKit
import SpriteKit

class PausedState: GKState {
    
    // MARK: - Properites
    
    var overlaySceneFileName: String {
        return "PauseScene"
    }
    
    unowned var levelScene: SKScene
    unowned var adapter: GameSceneAdapter
    var overlay: SceneOverlay!
    
    // MARK: - Intializers
    
    init(scene: SKScene, adapter: GameSceneAdapter) {
        self.levelScene = scene
        self.adapter = adapter
        super.init()
        // Look up for the pause button in order to be able to hide it when the state changes back and forth
        overlay = SceneOverlay(overlaySceneFileName: overlaySceneFileName, zPosition: 1000)
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        levelScene.isPaused = true
        adapter.overlay = overlay
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        levelScene.isPaused = false
        adapter.overlay = nil
    }
    
    // MARK: Convenience
    
    func button(withIdentifier identifier: ButtonIdentifier) -> ButtonNode? {
        return overlay.contentNode.childNode(withName: "//\(identifier.rawValue)") as? ButtonNode
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
}
