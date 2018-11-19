//
//  SKScene+ShaderTransition.swift
//  ios-spritekit-flappy-flying-bird
//
//  Created by Astemir Eleev on 02/06/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

private let kNodeNameTransitionShaderNode = "kNodeNameTransitionShaderNode"
private let kNodeNameFadeColourOverlay = "kNodeNameFadeColourOverlay"
private var presentationStartTime: CFTimeInterval = -1
private var shaderChoice = -1

extension SKScene {
    
    // MARK: - Properties
    
    private var transitionShader: SKShader? {
        get {
            if let shaderContainerNode = self.childNode(withName: kNodeNameTransitionShaderNode) as? SKSpriteNode {
                return shaderContainerNode.shader
            }
            
            return nil
        }
    }
    
    // MARK: - Methods
    
    func present(scene: SKScene?, shaderName: String, transitionDuration: TimeInterval) {
        // Create shader and add it to the scene
        let shaderContainer = SKSpriteNode(imageNamed: "dummy")
        shaderContainer.name = kNodeNameTransitionShaderNode
        shaderContainer.zPosition = 9999 // something arbitrarily large to ensure it's in the foreground
        shaderContainer.position = CGPoint(x: size.width / 2, y: size.height / 2)
        shaderContainer.size = CGSize(width: size.width, height: size.height)
        shaderContainer.shader = createShader(shaderName: shaderName, transitionDuration:transitionDuration)
        self.addChild(shaderContainer)
        
        // remove the shader from the scene after its animation has completed.
        let delayTime = DispatchTime.init(uptimeNanoseconds: UInt64(transitionDuration * Double(NSEC_PER_SEC)))
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            let fadeOverlay = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            fadeOverlay.name = kNodeNameFadeColourOverlay
            fadeOverlay.fillColor = SKColor(red: 131.0 / 255.0, green: 149.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            fadeOverlay.zPosition = shaderContainer.zPosition
            scene!.addChild(fadeOverlay)
            self.view!.presentScene(scene)
            
        }
        
        // Reset the time presentScene was called so that the elapsed time from now can
        // be calculated in updateShaderTransitions(currentTime:)
        presentationStartTime = -1
    }
    
    func updateShaderTransition(currentTime: CFTimeInterval) {
        if let shader = self.transitionShader {
            let elapsedTime = shader.uniformNamed("u_elapsed_time")!
            if (presentationStartTime < 0) {
                presentationStartTime = currentTime
            }
            elapsedTime.floatValue = Float(currentTime - presentationStartTime)
        }
    }
    
    /// The function is called by the scene being transitioned to when it's ready to have the view faded in to the scene i.e. loading is complete, etc.
    func completeShaderTransition() {
        if let fadeOverlay = self.childNode(withName: kNodeNameFadeColourOverlay) {
            fadeOverlay.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.3), SKAction.removeFromParent()]))
        }
    }
    
    // MARK: - Private methods
    
    private func createShader(shaderName: String, transitionDuration: TimeInterval) -> SKShader {
        let shader = SKShader(fileNamed:shaderName)
        
        let u_size = SKUniform(name: "u_size", vectorFloat3: vector3(Float(UIScreen.main.scale * size.width), Float(UIScreen.main.scale * size.height), 0.0))
        
        let u_fill_colour = SKUniform(name: "u_fill_colour", vectorFloat4: vector4(131.0 / 255.0, 149.0 / 255.0, 255.0 / 255.0, 1.0))
        let u_border_colour = SKUniform(name: "u_border_colour", vectorFloat4: vector4(104.0 / 255.0, 119.0 / 255.0, 204.0 / 255.0, 1.0))
        let u_total_animation_duration = SKUniform(name: "u_total_animation_duration", float: Float(transitionDuration))
        let u_elapsed_time = SKUniform(name: "u_elapsed_time", float: Float(0))
        shader.uniforms = [u_size, u_fill_colour, u_border_colour, u_total_animation_duration, u_elapsed_time]
        
        return shader
    }
    
}
