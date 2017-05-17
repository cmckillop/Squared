//
//  ScoresScene.swift
//  Squared
//
//  Created by Conor McKillop on 07/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

class ScoresScene: SKScene
{
    private var background = Background()
    
    private var scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView)
    {
        background.initAnimate(targetScene: self.scene!)
        initNodes()
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        background.animate()
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

        scoreLabel.name = "Score"
        scoreLabel.zPosition = 4
        scoreLabel.fontName = "SF UI Display Semibold"
        scoreLabel.fontSize = 72
        scoreLabel.position = CGPoint(x: 0, y: -26)
        scoreLabel.text = getHighScore()
        
        let scaleUp = SKAction.scale(to: 1.3, duration: 1)
        let scaleDown = SKAction.scale(to: 1, duration: 1)
        
        scoreLabel.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
        
        self.addChild(scoreLabel)
    }
    
    private func getHighScore() -> String
    {
        var highScore = Int()
        
        switch DataManager.sharedInstance.getDifficulty()
        {
            case .easy:
                highScore = DataManager.sharedInstance.getEasyScore()
            case .medium:
                highScore = DataManager.sharedInstance.getMediumScore()
            case .hard:
                highScore = DataManager.sharedInstance.getHardScore()
        }
        
        if highScore == 0
        {
            return "😔"
        }
        else
        {
            return String(highScore) + "m!"
        }
    }
}
