//
//  InstructionsScene.swift
//  Squared
//
//  Created by Conor McKillop on 16/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

class InstructionsScene: SKScene
{
 
    override func didMove(to view: SKView)
    {
        initNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            switch (self.atPoint(location).name ?? "")
            {
            case "Back Button":
                
                AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                if let scene = MenuScene(fileNamed: "MenuScene")
                {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.6))
                }
                
            default:
                break
            }
        }
    }
    
    private func initNodes()
    {
        let backButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Back Button")))
        backButton.name = "Back Button"
        backButton.zPosition = 3
        backButton.position = CGPoint(x: -300, y: 585)
        self.addChild(backButton)
    }
    
}
