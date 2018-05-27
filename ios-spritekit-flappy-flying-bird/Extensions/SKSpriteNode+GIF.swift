//
//  SKSpriteNode+GIF.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 27/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit
import ImageIO

extension SKSpriteNode {
    
    func animateWithLocalGIF(named name: String){
        
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            debugPrint(#function + " image with .gif extension does not exist")
                return
        }
        
        do {
            let imageData = try Data(contentsOf: bundleURL)

            if let textures = SKSpriteNode.gif(with: imageData as NSData) {
                let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
                self.run(action)
            }
        } catch {
            debugPrint(#function + " could not create data source from bundle URL: ", error)
        }
    }
    
    public class func gif(with data: NSData) -> [SKTexture]? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return SKSpriteNode.animatedImage(with: source)
    }
    
    class func animatedImage(with source: CGImageSource) -> [SKTexture]? {
        let count = CGImageSourceGetCount(source)
        var delays = [Int]()
        var textures = [SKTexture]()
        
        for i in 0..<count {

            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: image)
                textures.append(texture)
            }
        
            let delaySeconds = SKSpriteNode.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }
        
        return textures
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = SKSpriteNode.gcdForPair(a: val, b: gcd)
        }
        
        return gcd
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let unmanaged = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, unmanaged), to: CFDictionary.self)
        
        
        
        // Get delay time
        let unmanagedUnclampedDelay = Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, unmanagedUnclampedDelay), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            let unmanagedDelayTime = Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, unmanagedDelayTime), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int, b: Int) -> Int {
        var a = a
        var b = b
        
        // Swap for modulo
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a % b
            
            if rest == 0 {
                return b
            } else {
                a = b
                b = rest
            }
        }
    }
    
}
