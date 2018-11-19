//
//  SKScene.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 03/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit.SKScene
import SpriteKit.SKNode

extension SKScene {
    
    /// Uploads a set of scene graph nodes with a specific pattern
    ///
    /// - Parameters:
    ///   - key: is a String instnace that describes name of child nodes that will be uploaded
    ///   - pattern: is a closure that accepts string and int (as key and index) and returns string that decribes naming pattern
    ///   - indices: is an instnace of ClosedRange<Int> type that specifies index boundaries of uploading nodes (for instnace you want to upload a set of nodes that describe sky and are called "cloud" - there are 3 clouds: "cloud-1", "cloud-2", "cloud-3" - the method helps to upload them using a singe function)
    /// - Returns: an array containing Node types (Node is any type derived from SKNode class)s
    func upload<Node>(for key: String, with pattern: (_ key: String, _ index: Int)->String, inRange indices: ClosedRange<Int>) -> [Node] where Node: SKNode {
        
        var foundNodes = [Node]()
        
        for index in indices.lowerBound...indices.upperBound {
            let childName = pattern(key, index)
            guard let node = self.childNode(withName: childName) as? Node else {
                debugPrint(#function + " could not find child with the following name: ", childName)
                continue
            }
            foundNodes.append(node)
        }
        
        return foundNodes
    }
}
