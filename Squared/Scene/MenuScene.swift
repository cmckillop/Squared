//
//  MenuScene.swift
//  Squared
//
//  Created by Conor McKillop on 07/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene
{
    private var background = Background()
    
    override func didMove(to view: SKView)
    {
        DataManager.sharedInstance.initialise()
        AudioManager.sharedInstance.ambientAudioVolume(inGame: false)
        
        background.initAnimate(targetScene: self.scene!)
        initLabel()
        initAudio()
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        background.animate()
        AudioManager.sharedInstance.checkQueue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            switch (self.atPoint(location).name ?? "")
            {
            case "Play":
                
                AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                DataManager.sharedInstance.gameState = GameState.new
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                if let scene = GameScene(fileNamed: "GameScene")
                {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene, transition: SKTransition.doorway(withDuration: 1.2))
                }
                
            case "Scores":
                
                AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                if let scene = ScoresScene(fileNamed: "ScoresScene")
                {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.6))
                }
                
            case "Settings":
                
                AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                if let scene = SettingsScene(fileNamed: "SettingsScene")
                {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.6))
                }
                
            case "Instructions":
                
                AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                if let scene = InstructionsScene(fileNamed: "InstructionsScene")
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
    
    private func initLabel()
    {
        let titleLabel = SKLabelNode()
        
        titleLabel.fontName = "SF UI Display Semibold"
        titleLabel.fontSize = 100
        titleLabel.position = CGPoint(x: 17, y: 388)
        titleLabel.zPosition = 5
        titleLabel.text = "Squared²"
        
        self.addChild(titleLabel)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 1.6)
        let scaleDown = SKAction.scale(to: 1, duration: 1.6)
        
        titleLabel.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
    }
    
    private func initAudio()
    {
        AudioManager.sharedInstance.initEffectPlayer()
        if DataManager.sharedInstance.getAudioStatus()
        {
            if AudioManager.sharedInstance.isPlayerInitialised()
            {
                AudioManager.sharedInstance.playAmbientAudio()
            }
        }
    }
}
