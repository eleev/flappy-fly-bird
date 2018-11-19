//
//  SKTexture+Gradient.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 06/05/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit.SKTexture

extension SKTexture {
    
    enum GradientDirection {
        case up
        case left
        case upLeft
        case upRight
    }
    
    convenience init(size: CGSize, startColor: SKColor, endColor: SKColor, direction: GradientDirection = .up) {
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")!
        let startVector: CIVector
        let endVector: CIVector
        
        filter.setDefaults()
        
        switch direction {
        case .up:
            startVector = CIVector(x: size.width/2, y: 0)
            endVector   = CIVector(x: size.width/2, y: size.height)
        case .left:
            startVector = CIVector(x: size.width, y: size.height/2)
            endVector   = CIVector(x: 0, y: size.height/2)
        case .upLeft:
            startVector = CIVector(x: size.width, y: 0)
            endVector   = CIVector(x: 0, y: size.height)
        case .upRight:
            startVector = CIVector(x: 0, y: 0)
            endVector   = CIVector(x: size.width, y: size.height)
        }
        
        filter.setValue(startVector, forKey: "inputPoint0")
        filter.setValue(endVector, forKey: "inputPoint1")
        filter.setValue(CIColor(color: startColor), forKey: "inputColor0")
        filter.setValue(CIColor(color: endColor), forKey: "inputColor1")
        
        let image = context.createCGImage(filter.outputImage!, from: CGRect(origin: .zero, size: size))
        
        self.init(cgImage: image!)
    }
}
