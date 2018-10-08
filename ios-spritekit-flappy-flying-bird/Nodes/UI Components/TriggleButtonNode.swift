//
//  TriggleButtonNode.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 08/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

/// A type that can respond to `TriggleButtonNode` button press events.
protocol TriggleButtonNodeResponderType: class {
    /// Responds to a button press.
    func triggleButtonTriggered(triggle: TriggleButtonNode)
}

class TriggleButtonNode: ButtonNode {
    
    // MARK: - Custom types
    
    enum TriggleState {
        case off
        case switched
        case on
        
        static func convert(from difficultyLevel: Difficulty) -> TriggleState {
            switch difficultyLevel {
            case .easy:
                return .off
            case .medium:
                return .switched
            case .hard:
                return .on
            }
        }
    }
    
    struct Triggle {
        
        // MARK: - Properties
        
        private(set) var off: Bool
        private(set) var switched: Bool
        private(set) var on: Bool
        private var lastTriggleState: TriggleState
        
        // MARK: - Initializers
        
        init(state: TriggleState) {
            switch state {
            case .off:
                off = true
                switched = false
                on = false
                lastTriggleState = .off
            case .switched:
                off = false
                switched = true
                on = false
                lastTriggleState = .switched
            case .on:
                off = false
                switched = false
                on = true
                lastTriggleState = .on
            }
        }
        
        // MARK: - Methods
        
        mutating func switchState() {
            if off {
                off = !off
                switched = !switched
                lastTriggleState = .switched
            } else if switched {
                switched = !switched
                on = !on
                lastTriggleState = .on
            } else if on {
                on = !on
                off = !off
                lastTriggleState = .off
            }
        }
        
        func state() -> TriggleState {
           return lastTriggleState
        }
        
        func toDifficultyLevel() -> Difficulty {
            switch lastTriggleState {
            case .off:
                return Difficulty.easy
            case .switched:
                return Difficulty.medium
            case .on:
                return Difficulty.hard
            }
        }
        
    }
    
    // MARK: - Properties
    
    var triggle: Triggle {
        didSet {
            guard let off = state.off, let switched = state.switched, let on = state.on else {
                return
            }
            on.isHidden = !triggle.on
            off.isHidden = !triggle.off
            switched.isHidden = !triggle.switched
            
            if isUserInteractionEnabled {
                triggleResponder.triggleButtonTriggered(triggle: self)
            }
        }
    }
    
    private var state: (off: SKLabelNode?, switched: SKLabelNode?, on: SKLabelNode?) = (off: nil, switched: nil, on: nil)
    
    var triggleResponder: TriggleButtonNodeResponderType {
        guard let responder = scene as? TriggleButtonNodeResponderType else {
            fatalError("ButtonNode may only be used within a `ButtonNodeResponderType` scene.")
        }
        return responder
    }
    
    
    // MARK: - Initialisers
    
    required init?(coder aDecoder: NSCoder) {
        let difficultyLevel = UserDefaults.standard.getDifficultyLevel()
        triggle = .init(state: TriggleState.convert(from: difficultyLevel))
        
        super.init(coder: aDecoder)
        
        guard let offState = childNode(withName: "Easy") as? SKLabelNode else {
            fatalError("Could not find SKLabel node")
        }
        state.off = offState
        
        guard let switchedState = childNode(withName: "Medium") as? SKLabelNode else {
            fatalError("Could not find SKLabel node")
        }
        state.switched = switchedState
        
        guard let onState = childNode(withName: "Hard") as? SKLabelNode else {
            fatalError("Could not find SKLabel node")
        }
        state.on = onState
        
    }
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        triggle.switchState()
    }
}
