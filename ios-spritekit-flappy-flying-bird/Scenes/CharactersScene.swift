//
//  CharactersScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 26/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class CharactersScene: RoutingUtilityScene {
    
    // MARK: - Properties
    
    private var selectNode: SKShapeNode?
    private var playableCharacters: [PlayableCharacter : SKNode] = [:]
    
    // MARK: - Overrides
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        func preparePlayableCharacters() {
            let birdNode = childNode(withName: PlayableCharacter.bird.rawValue) as? SKSpriteNode
            playableCharacters[.bird] = birdNode
            
            let scale = CGPoint(x: 0.6, y: 0.6)
            
            let gameCat = childNode(withName: PlayableCharacter.gamecat.rawValue) as? NyancatNode
            gameCat?.xScale = scale.x
            gameCat?.yScale = scale.y
            playableCharacters[.gamecat] = gameCat
            
            let coinCat = childNode(withName: PlayableCharacter.coinCat.rawValue) as? NyancatNode
            coinCat?.xScale = scale.x
            coinCat?.yScale = scale.y
            playableCharacters[.coinCat] = coinCat
            
            let hipCat = childNode(withName: PlayableCharacter.hipCat.rawValue) as? NyancatNode
            hipCat?.xScale = scale.x
            hipCat?.yScale = scale.y
            playableCharacters[.hipCat] = hipCat
            
            let jazzCat = childNode(withName: PlayableCharacter.jazzCat.rawValue) as? NyancatNode
            jazzCat?.xScale = scale.x
            jazzCat?.yScale = scale.y
            playableCharacters[.jazzCat] = jazzCat
            
            let lifelopeCat = childNode(withName: PlayableCharacter.lifelopeCat.rawValue) as? NyancatNode
            lifelopeCat?.xScale = scale.x
            lifelopeCat?.yScale = scale.y
            playableCharacters[.lifelopeCat] = lifelopeCat
        }
        
        selectNode = childNode(withName: "Select Node") as? SKShapeNode
        preparePlayableCharacters()
      
        func loadSelectedChacter() {
            let playableCharacter = UserDefaults.standard.playableCharacter(for: .character) ?? .bird
            select(playableCharacter: playableCharacter, animated: false)
        }
        loadSelectedChacter()
    }
    
    // MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        let touchedNodes = self.nodes(at: location)
        
        guard let firstTouchedNode = touchedNodes.first else {
            return
        }
        
        guard let name = firstTouchedNode.name, let selectedPlayableCharacter = PlayableCharacter(rawValue: name) else {
            return
        }
        
        UserDefaults.standard.set(selectedPlayableCharacter, for: .character)
        select(playableCharacter: selectedPlayableCharacter, animated: true)
    }
    
    // MARK: - Selection Utils
    
    private func select(playableCharacter: PlayableCharacter, animated: Bool) {
        guard let playableCharacterNode = playableCharacters[playableCharacter] else {
            return
        }
        
        if animated {
            let hide = SKAction.fadeOut(withDuration: 0.15)
            let unhide = SKAction.fadeIn(withDuration: 0.15)
            let move = SKAction.move(to: playableCharacterNode.position, duration: 0.0)
            let sequece = SKAction.sequence([hide, move, unhide])
            selectNode?.run(sequece)
        } else {
            selectNode?.position = playableCharacterNode.position
        }
    }
    
}
