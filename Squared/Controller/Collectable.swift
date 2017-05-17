//
//  Collectable.swift
//  Squared
//
//  Created by Conor McKillop on 08/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

enum Collectables: String
{
    case life = "Life"
    case slowCamera = "Slow Camera"
    case dud = "Dud"
}

class Collectable
{
    func createLife() -> SKSpriteNode
    {
        var collectable = SKSpriteNode()
        
        if GameManager.sharedInstance.getLifeCount() < 3
        {
            
            collectable = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Life")))
            collectable.name = Collectables.life.rawValue
            collectable.physicsBody = SKPhysicsBody(rectangleOf: collectable.size)
            
            collectable.physicsBody?.affectedByGravity = false
            collectable.physicsBody?.categoryBitMask = BitMask.Collectable
            collectable.zPosition = 2

        }
        else
        {
            collectable.name = Collectables.dud.rawValue
        }
        
        return collectable
    }
    
    func createSlowCamera() -> SKSpriteNode
    {
        var collectable = SKSpriteNode()
        
        if GameManager.sharedInstance.isSlowCameraActive() == false
        {
            collectable = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Slow Camera")))
            collectable.name = Collectables.slowCamera.rawValue
            collectable.physicsBody = SKPhysicsBody(circleOfRadius: (collectable.size.width / 2))
            
            collectable.physicsBody?.affectedByGravity = false
            collectable.physicsBody?.categoryBitMask = BitMask.Collectable
            collectable.zPosition = 2
        }
        else
        {
            collectable.name = Collectables.dud.rawValue
        }
        
        return collectable
    }
}
