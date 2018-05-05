//
//  ButtonNode.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 05/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode, Touchable {
    
    // MARK: - Properties
    
    var fontType: String = "Pixel Digivolve"
    var touchHandler: ((_ isPressed: Bool) -> Void)?
    
    private(set) var textures: (idle: SKTexture, pressed: SKTexture)
    private(set) var labels: (idle: String, pressed: String)
    private(set) var labelNode: SKLabelNode
    
    private(set) var isPressed: Bool = false
    
    override var zPosition: CGFloat {
        didSet {
            labelNode.zPosition = zPosition + 1
        }
    }
    
    // MARK: - Initializers
    
    init(spriteNames: (idle: String, pressed: String), labels: (idle: String, pressed: String) , fontSize: CGFloat, size: CGSize) {
        let idleTexture = SKTexture(imageNamed: spriteNames.idle)
        let pressedTexture = SKTexture(imageNamed: spriteNames.pressed)
        
        textures = (idle: idleTexture, pressed: pressedTexture)
        self.labels = labels
        
        labelNode = SKLabelNode(fontNamed: fontType)
        labelNode.fontSize = fontSize
        labelNode.text = self.labels.idle
        
        super.init(texture: idleTexture, color: .clear, size: size)
        
        self.addChild(labelNode)
        
        // Adjust the position of Label Node
        labelNode.position.y -= (labelNode.frame.maxY / 2)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overriden methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch isPressed {
        case true:
            self.texture = textures.pressed
            self.labelNode.text = labels.pressed
        case false:
            self.texture = textures.idle
            self.labelNode.text = labels.idle
        }
        
        isPressed = !isPressed
        touchHandler?(isPressed)
    }
}
