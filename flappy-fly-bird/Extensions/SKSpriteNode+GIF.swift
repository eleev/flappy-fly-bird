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
    
    convenience init(withAnimatedGif name: String, correctAspectRatioFor width: CGFloat) {
        self.init(texture: nil, color: .clear, size: .zero)
        animateWithLocalAspectCorrectGIF(named: name, width: width)
    }
    
    func animateWithLocalAspectCorrectGIF(named name: String, width: CGFloat) {
        guard let size = animateWithLocalGIF(named: name) else {
            debugPrint(#function + " could not unwrap size of the GIF texture - the method will be aborted")
            return
        }
        
        let aspect = size.width / size.height
        let newHeight = size.width / aspect
        self.size.width = size.width
        self.size.height = newHeight
    }
    
    @discardableResult
    func animateWithLocalGIF(named name: String) -> CGSize? {
        
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            debugPrint(#function + " image with .gif extension does not exist")
                return nil
        }
        
        do {
            let imageData = try Data(contentsOf: bundleURL)
            let data =  SKSpriteNode.gif(with: imageData as NSData)
            
            guard let textures = data.0 else  {
                return nil
            }
            
            let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: data.1[0]))
            self.run(action)
            
            return textures.first?.size()
        } catch {
            debugPrint(#function + " could not create data source from bundle URL: ", error)
            return nil
        }
    }
    
    class func gif(with data: NSData) -> ([SKTexture]?, [Double]) {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return (nil, [])
        }
        
        return SKSpriteNode.animatedImage(with: source)
    }
    
    class func animatedImage(with source: CGImageSource) -> ([SKTexture]?, [Double]) {
        let count = CGImageSourceGetCount(source)
        var delays = [Double]()
        var textures = [SKTexture]()
        
        for i in 0..<count {

            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: image)
                textures.append(texture)
            }
        
            let delaySeconds = SKSpriteNode.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(delaySeconds)
        }
        
        return (textures, delays)
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty { return 1 }
        var gcd = array[0]
        
        array.forEach { val in
            gcd = SKSpriteNode.gcdFor(pair: val, target: gcd)
        }
        
        return gcd
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.01 { delay = 0.01 }

        return delay
    }
    
    class func gcdFor(pair value: Int, target: Int) -> Int {
        var a = value
        var b = target

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
            
            if rest == 0 { return b }
            else {
                a = b
                b = rest
            }
        }
    }
    
}
