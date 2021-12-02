//
//  Updatable.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

protocol Updatable: AnyObject {
    
    // MARK: - Properties
    
    var delta: TimeInterval { get }
    var lastUpdateTime: TimeInterval { get }
    var shouldUpdate: Bool { get set }
    
    // MARK: - Methods
    
    func update(_ currentTime: TimeInterval)
}


extension Updatable {
    
    /// Ensures that frame updates happen with the same time interval between each frame
    ///
    /// - Parameter currentTime: you need to pass here the current time (TimeInterval) from the scene update method
    /// - Returns: is a tuple containing computed delta and lastUpdateTime properties that need to be set to the protocol properties
    func computeUpdatable(currentTime: TimeInterval) -> (delta: TimeInterval, lastUpdateTime: TimeInterval) {
        let delta = (self.lastUpdateTime == 0.0) ? 0.0 : currentTime - self.lastUpdateTime
        let lastUpdateTime = currentTime
        
        return (delta: delta, lastUpdateTime: lastUpdateTime)
    }
}
