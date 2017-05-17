//
//  SettingsScene.swift
//  Squared
//
//  Created by Conor McKillop on 07/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

enum Difficulty: String
{
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

class SettingsScene: SKScene
{
    private var background = Background()
    
    private var difficultyButton = SKSpriteNode(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), size: CGSize(width: 300, height: 300))
    private var soundButton = SKSpriteNode(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), size: CGSize(width: 140, height: 140))
    
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
            case "Difficulty Button":
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                switch DataManager.sharedInstance.getDifficulty()
                {
                case .easy:
                    setDifficulty(newDifficulty: .medium)
                case .medium:
                    setDifficulty(newDifficulty: .hard)
                case .hard:
                    setDifficulty(newDifficulty: .easy)
                }
                
            case "Sound Button":
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                updateAudioButton()
                
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
        difficultyButton.name = "Difficulty Button"
        difficultyButton.zPosition = 3
        difficultyButton.position = CGPoint(x: 0, y: 300)
        self.addChild(difficultyButton)
        updateDifficultyNode()
        
        let difficultyLabel = SKLabelNode()
        difficultyLabel.fontName = "SF UI Display Regular"
        difficultyLabel.fontSize = 48
        difficultyLabel.zPosition = 3
        difficultyLabel.position = CGPoint(x: 0, y: 480)
        difficultyLabel.text = "Difficulty"
        self.addChild(difficultyLabel)
        
        soundButton.name = "Sound Button"
        soundButton.zPosition = 3
        soundButton.position = CGPoint(x: 0, y: -100)
        self.addChild(soundButton)
        setAudioButton()
        
        let soundLabel = SKLabelNode()
        soundLabel.fontName = "SF UI Display Regular"
        soundLabel.fontSize = 48
        soundLabel.zPosition = 3
        soundLabel.position = CGPoint(x: 0, y: -9)
        soundLabel.text = "Sound"
        self.addChild(soundLabel)
        
        let backButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Back Button")))
        backButton.name = "Back Button"
        backButton.zPosition = 3
        backButton.position = CGPoint(x: -300, y: 585)
        self.addChild(backButton)
    }
    
    private func setDifficulty(newDifficulty: Difficulty)
    {
        switch newDifficulty
        {
            case .easy:
                DataManager.sharedInstance.setDifficulty(difficulty: Difficulty.easy)
            case .medium:
                DataManager.sharedInstance.setDifficulty(difficulty: Difficulty.medium)
            case .hard:
                DataManager.sharedInstance.setDifficulty(difficulty: Difficulty.hard)
        }
        updateDifficultyNode()
    }
    
    private func updateDifficultyNode()
    {
        switch DataManager.sharedInstance.getDifficulty()
        {
        case .easy:
            difficultyButton.texture = SKTexture(image: #imageLiteral(resourceName: "Easy Button"))
        case .medium:
            difficultyButton.texture = SKTexture(image: #imageLiteral(resourceName: "Medium Button"))
        case .hard:
            difficultyButton.texture = SKTexture(image: #imageLiteral(resourceName: "Hard Button"))
        }
    }
    
    private func setAudioButton()
    {
        
        if DataManager.sharedInstance.getAudioStatus()
        {
            soundButton.texture = SKTexture(image: #imageLiteral(resourceName: "Sound Button"))
        }
        else
        {
            soundButton.texture = SKTexture(image: #imageLiteral(resourceName: "Muted Button"))
        }
    }
    
    private func updateAudioButton()
    {
        if DataManager.sharedInstance.getAudioStatus()
        {
            DataManager.sharedInstance.setAudioStatus(isAudioOn: false)
            AudioManager.sharedInstance.stopAmbientAudio()
            soundButton.texture = SKTexture(image: #imageLiteral(resourceName: "Muted Button"))
        }
        else
        {
            DataManager.sharedInstance.setAudioStatus(isAudioOn: true)
            AudioManager.sharedInstance.playAmbientAudio()
            soundButton.texture = SKTexture(image: #imageLiteral(resourceName: "Sound Button"))
        }
    }
}
