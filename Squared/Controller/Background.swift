//
//  Background.swift
//  Squared
//
//  Created by Conor McKillop on 08/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode
{
    private var targetScene = SKScene()
    private var backgrounds = [SKSpriteNode]()
    
    func initMove(targetScene: SKScene)
    {
        
        for i in 0...2
        {
            let background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Background")))
            background.name = "Background"
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.position = CGPoint(x: 0, y: (CGFloat(i) * background.size.height))
            background.zPosition = 0
            
            backgrounds.append(background)
            self.targetScene = targetScene
            self.targetScene.addChild(background)
        }
    }
    
    func initAnimate(targetScene: SKScene)
    {
        for i in 0...2
        {
            let background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Background")))
            background.name = "Background"
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.position = CGPoint(x: 0, y: (CGFloat(i) * background.size.height))
            background.zPosition = 0
            
            self.targetScene = targetScene
            self.targetScene.addChild(background)
        }
    }
    
    func move(camera: SKCameraNode)
    {
        // Move background when camera is completely out of view (by 10 pixels)
        for i in 0...2
        {
            if (backgrounds[i].position.y + targetScene.size.height + 10) < camera.position.y
            {
                backgrounds[i].position.y += backgrounds[i].size.height * 3
            }
        }
    }
    
    // Object Pooling Design Pattern
    func animate()
    {
        targetScene.enumerateChildNodes(withName: "Background", using: (
            {
                (node, error) in
                
                let backgroundNode = node as! SKSpriteNode
                backgroundNode.position.y -= 4
                
                if backgroundNode.position.y < -(self.targetScene.frame.height)
                {
                    backgroundNode.position.y += (backgroundNode.size.height * 3)
                }
        }))
    }
}
