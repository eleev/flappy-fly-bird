//
//  CharactersScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 26/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class CharactersScene: RoutingUtilityScene {
    
    private var selectNode: SKShapeNode?
    private var playableCharacters: [PlayableCharacter : SKNode] = [:]
    
    // MARK: - Overrides
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        selectNode = childNode(withName: "Select Node") as? SKShapeNode
        
        playableCharacters[.bird] = childNode(withName: "bird") as? SKSpriteNode
        
        let nyancatNode = childNode(withName: "nyancatAnim") as? NyancatNode
        nyancatNode?.removeFromParent()
        let newNyancatNode = NyancatNode(size: (nyancatNode?.size)!, parentScene: self)
        newNyancatNode.position = (nyancatNode?.position)!
        newNyancatNode.isAffectedByGravity = false
        self.addChild(newNyancatNode)
        
        playableCharacters[.nyancatAnim] = nyancatNode
        
        
        let playableCharacter = UserDefaults.standard.playableCharacter(for: .character) ?? .bird
        select(playableCharacter: playableCharacter)
    }
    
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
        select(playableCharacter: selectedPlayableCharacter)
    }
    
    // MARK: - Selection Utils
    
    private func select(playableCharacter: PlayableCharacter) {
        guard let playableCharacterNode = playableCharacters[playableCharacter] else {
            return
        }
        
        selectNode?.position = playableCharacterNode.position
    }
    
}
