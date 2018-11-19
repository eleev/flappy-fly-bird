//
//  ToggleButtonNode.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 17/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

/// A type that can respond to `ToggleButtonNode` button press events.
protocol ToggleButtonNodeResponderType: class {
    /// Responds to a button press.
    func toggleButtonTriggered(toggle: ToggleButtonNode)
}

class ToggleButtonNode: ButtonNode {
    
    // MARK: - Properties
    
    var isOn: Bool {
        didSet {
            guard let on = state.on, let off = state.off else {
                return
            }
            
            on.isHidden = !isOn
            off.isHidden = isOn
            
            if isUserInteractionEnabled {
                toggleResponder.toggleButtonTriggered(toggle: self)
            }
        }
    }
    
    private var state: (on: SKLabelNode?, off: SKLabelNode?) = (on: nil, off: nil)
    
    /**
     The scene that contains a `ToggleButtonNode` must be a `ToggleButtonNodeResponderType`
     so that touch events can be forwarded along through `toggled`.
     */
    var toggleResponder: ToggleButtonNodeResponderType {
        guard let responder = scene as? ToggleButtonNodeResponderType else {
            fatalError("ButtonNode may only be used within a `ButtonNodeResponderType` scene.")
        }
        return responder
    }
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        let isSoundOn = UserDefaults.standard.bool(for: .isSoundOn)
        isOn = isSoundOn
        
        super.init(coder: aDecoder)
        
        guard let onState = self.childNode(withName: "On") as? SKLabelNode else  {
            fatalError("Could not find SKLabel node")
        }
        state.on = onState
        
        guard let offState = self.childNode(withName: "Off") as? SKLabelNode else {
            fatalError("Could not find SKLabel node")
        }
        state.off = offState
    }
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // Toggle the state and visuals
        isOn = !isOn
    }
}

