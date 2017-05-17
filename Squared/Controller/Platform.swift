//
//  Platform.swift
//  Squared
//
//  Created by Conor McKillop on 08/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit
import GameKit

class Platform
{
    private let collectableGenerator = Collectable()
    private var lastPlatformPositionY = CGFloat()
    private var platformBuffer = CGFloat(250)
    private var platformMaxX = CGFloat(265)
    private var platformMinX = CGFloat(-265)
    
    private func initPlatforms() -> [SKSpriteNode]
    {
        var platforms = [SKSpriteNode]()
        
        for _ in 0..<2
        {
            let platformType1 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Platform 1")))
            
            platformType1.name = "Platform 1"
            platformType1.size = CGSize(width: CGFloat.randomFromRange(numA: 210, numB: 300), height: 38)
            platformType1.physicsBody = SKPhysicsBody(rectangleOf: platformType1.size)
            platformType1.physicsBody?.affectedByGravity = false
            platformType1.physicsBody?.allowsRotation = false
            platformType1.physicsBody?.isDynamic = false
            platformType1.physicsBody?.restitution = 0
            platformType1.physicsBody?.categoryBitMask = BitMask.Platform
            
            platforms.append(platformType1)
            
            let platformType2 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Platform 2")))
            
            platformType2.name = "Platform 2"
            platformType2.size = CGSize(width: CGFloat.randomFromRange(numA: 210, numB: 300), height: 38)
            platformType2.physicsBody = SKPhysicsBody(rectangleOf: platformType2.size)
            platformType2.physicsBody?.affectedByGravity = false
            platformType2.physicsBody?.allowsRotation = false
            platformType2.physicsBody?.isDynamic = false
            platformType2.physicsBody?.restitution = 0
            platformType2.physicsBody?.categoryBitMask = BitMask.Platform
            
            platforms.append(platformType2)
            
            let platformType3 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Platform 3")))
            
            platformType3.name = "Platform 3"
            platformType3.size = CGSize(width: CGFloat.randomFromRange(numA: 210, numB: 300), height: 38)
            platformType3.physicsBody = SKPhysicsBody(rectangleOf: platformType3.size)
            platformType3.physicsBody?.affectedByGravity = false
            platformType3.physicsBody?.allowsRotation = false
            platformType3.physicsBody?.isDynamic = false
            platformType3.physicsBody?.restitution = 0
            platformType3.physicsBody?.categoryBitMask = BitMask.Platform
            
            platforms.append(platformType3)
            
            let killPlatform = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Platform Enemy")))
            
            killPlatform.name = "Kill Platform"
            killPlatform.size = CGSize(width: CGFloat.randomFromRange(numA: 210, numB: 300), height: 38)
            killPlatform.physicsBody = SKPhysicsBody(rectangleOf: killPlatform.size)
            killPlatform.physicsBody?.affectedByGravity = false
            killPlatform.physicsBody?.allowsRotation = false
            killPlatform.physicsBody?.isDynamic = false
            killPlatform.physicsBody?.restitution = 0
            
            killPlatform.physicsBody?.categoryBitMask = BitMask.Enemy
            
            platforms.append(killPlatform)
        }
        
        platforms = randomiseArray(array: platforms)
        return platforms
    }
    
    func insertPlatforms(scene: SKScene, player: Player, isFirstPlatform: Bool)
    {
        var PositionY = CGFloat()
        
        var platforms = initPlatforms()
        
        if isFirstPlatform
        {
            while(platforms[0].physicsBody?.categoryBitMask == BitMask.Enemy)
            {
                platforms = randomiseArray(array: platforms)
            }
            
            PositionY = -100
        }
        else
        {
            PositionY = lastPlatformPositionY
        }
        
        var createdLife = false
        var createdSlowCamera = false
        
        for platform in platforms
        {
            var randomPositionX = CGFloat()
            
            if platforms.index(of: platform)! % 2 == 0
            {
                randomPositionX = CGFloat.randomFromRange(numA: 160, numB: platformMaxX)
            }
            else
            {
                randomPositionX = CGFloat.randomFromRange(numA: platformMinX, numB: -160)
            }
            
            platform.position = CGPoint(x: randomPositionX, y: PositionY)
            platform.zPosition = 1
            
            // Create Collectables if this is not the first generated platforms
            if !isFirstPlatform && platform.physicsBody?.categoryBitMask != BitMask.Enemy
            {
                let randomNumber = CGFloat.randomFromRange(numA: 0, numB: 10)
                
                if randomNumber >= 8 && !createdLife
                {
                    let collectable = collectableGenerator.createLife()
                    collectable.position = CGPoint(x: platform.position.x, y: platform.position.y + 85)
                    scene.addChild(collectable)
                    createdLife = true
                }
                else if randomNumber <= 4 && !createdSlowCamera
                {
                    let collectable = collectableGenerator.createSlowCamera()
                    collectable.position = CGPoint(x: platform.position.x, y: platform.position.y + 85)
                    scene.addChild(collectable)
                    createdSlowCamera = true
                }
            }
            
            scene.addChild(platform)
            PositionY += platformBuffer
            lastPlatformPositionY = PositionY
        }
        
        if isFirstPlatform
        {
            player.position = CGPoint(x: platforms[0].position.x, y: (platforms[0].position.y + 85))
        }
        
    }
    
    private func randomiseArray(array: [SKSpriteNode]) -> [SKSpriteNode]
    {
        var randomisedArray = array
        
        // Use GameKit function to shuffle the array of SKSpriteNode
        randomisedArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: array) as! [SKSpriteNode]
        return randomisedArray
    }
}
