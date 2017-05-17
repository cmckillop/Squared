//
//  Camera.swift
//  Squared
//
//  Created by Conor McKillop on 08/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

class Camera: SKCameraNode
{
    private var yAcceleration = CGFloat(0)
    private var maxSpeed = CGFloat(0)
    private var currentSpeed = CGFloat(0)
    private var slowedSpeed = CGFloat(2)
    
    func initialise(yAcceleration: CGFloat, startingSpeed: CGFloat, maxSpeed: CGFloat)
    {
        self.name = "Camera"
        self.position = CGPoint(x: (0), y: (0))
        self.yAcceleration = yAcceleration
        self.maxSpeed = maxSpeed
        self.currentSpeed = startingSpeed
    }
    
    func move()
    {
        if !GameManager.sharedInstance.isSlowCameraActive()
        {
            currentSpeed += yAcceleration
            if currentSpeed > maxSpeed
            {
                currentSpeed = maxSpeed
            }
            self.position.y += currentSpeed
        }
        else
        {
            self.position.y += slowedSpeed
        }
    }
}
