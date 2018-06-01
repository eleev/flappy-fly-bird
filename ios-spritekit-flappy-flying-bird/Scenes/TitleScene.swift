//
//  TitleScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 06/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class TitleScene: RoutingUtilityScene {
    
    // MARK: - Overrides
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        loadSelectedPlayer()
        
        let isSoundOn = UserDefaults.standard.bool(for: .isSoundOn)
        
        if !isSoundOn {
            let audioNode = childNode(withName: "Audio Node") as? SKAudioNode
            audioNode?.isPaused = true
            audioNode?.removeAllActions()
            audioNode?.removeFromParent()
        }
    }
    
    // MARK: - Private methods
    
    private func loadSelectedPlayer() {
        guard let targetNode = childNode(withName: "Animated Bird") else {
            return
        }
        
        let playableCharacter = UserDefaults.standard.playableCharacter(for: .character) ?? .bird
        
        let assetName = playableCharacter.getAssetName()
        let playerSize = CGSize(width: 200, height: 200)
        
        switch playableCharacter {
        case .bird:
            let birdNode = BirdNode(animationTimeInterval: 0.1, withTextureAtlas: assetName, size: playerSize)
            birdNode.isAffectedByGravity = false
            birdNode.position = targetNode.position
            birdNode.zPosition = targetNode.zPosition
            scene?.addChild(birdNode)
        case .coinCat, .gamecat, .hipCat, .jazzCat, .lifelopeCat:
            let player = NyancatNode(animatedGif: assetName, correctAspectRatioFor: playerSize.width)
            player.xScale = 1.0
            player.yScale = 1.0
            
            player.isAffectedByGravity = false
            player.position = targetNode.position
            player.zPosition = targetNode.zPosition
            scene?.addChild(player)
        }
        
        targetNode.removeFromParent()
    }
}
