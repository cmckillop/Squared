//
//  Player.swift
//  Squared
//
//  Created by Conor McKillop on 06/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

struct BitMask
{
    static let Player: UInt32 = 0
    static let Platform: UInt32 = 1
    static let Enemy: UInt32 = 2
    static let Collectable: UInt32 = 3
}

enum Direction
{
    case left
    case right
    case neutral
}

enum State
{
    case normal
    case effort
    case distress
}

class Player: SKSpriteNode
{

    private var currentState = State.normal
    private var jumpForce = CGFloat(750)
    
    private let minXPosition = CGFloat(-308)
    private let maxXPosition = CGFloat(308)
    private let maxYPosition = CGFloat(735)
    private let minYPosition = CGFloat(-735)
    
    func initialise()
    {
        self.name = "Player"
        self.zPosition = 2
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.setScale(1)
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.restitution = 0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = BitMask.Player
        self.physicsBody?.collisionBitMask = BitMask.Platform | BitMask.Enemy
        self.physicsBody?.contactTestBitMask = BitMask.Collectable
    }
    
    func move(playerDirection: Direction)
    {
        switch playerDirection
        {
            case .left:
                self.position.x -= 4
            case .right:
                self.position.x += 4
            case .neutral:
                break
        }
        
        if self.position.x > maxXPosition
        {
            self.position.x = maxXPosition
        }
        
        if self.position.x < minXPosition
        {
            self.position.x = minXPosition
        }
    }
    
    func jump()
    {
        // Normalise Velocity Force
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
    }
    
    func changeState(newState: State)
    {
        if newState != currentState
        {
            currentState = newState
            
            switch self.currentState
            {
                case .normal:
                    self.texture = SKTexture(image: #imageLiteral(resourceName: "Player"))
                case .effort:
                    self.texture = SKTexture(image: #imageLiteral(resourceName: "Player (Effort)"))
                case .distress:
                    self.texture = SKTexture(image: #imageLiteral(resourceName: "Player (Distress)"))
            }
        }
    }
}
