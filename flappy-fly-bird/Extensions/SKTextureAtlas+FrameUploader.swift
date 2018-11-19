//
//  SKTextureAtlas.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 03/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit.SKTextureAtlas
import SpriteKit.SKTexture

extension SKTextureAtlas {
    
    /// Uploads an animation sequence from a texture atlas and returns an array of textures that can be futher used
    ///
    /// - Parameters:
    ///   - named: is a texture atlas name
    ///   - beginIndex: is a begin index that differentiates frames (for instnace the very first frame can named "player-0" or "player-1", the index helps in pattern matching)
    ///   - pattern: is a closure that accepts name of a frame and index (index is incremented internally) and returns a string instnace that is used as texture atlas naming pattern
    /// - Returns: an array of SKTexture instances, each containing a singe frame of key-frame animation
    /// - Throws: an instnace of NSError with exit code 1, no user-related info and domain-specific error explanation
    class func upload(named name: String, beginIndex: Int = 1, pattern: (_ name: String, _ index: Int) -> String) throws -> [SKTexture] {
        
        let atlas = SKTextureAtlas(named: name)
        var frames = [SKTexture]()
        let count = atlas.textureNames.count
        
        if beginIndex > count {
            throw NSError(domain: "Begin index is grather than the number of texture in a the texture atlas named: \(name)", code: 1, userInfo: nil)
        }
        
        for index in beginIndex...count {
            let namePattern = pattern(name, index)
            let texture = atlas.textureNamed(namePattern)
            frames.append(texture)
        }
        
        return frames
    }
}


