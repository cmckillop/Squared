//
//  GameScene.swift
//  Squared
//
//  Created by Conor McKillop on 06/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    private var player = Player()
    private var playerJumping = false
    private var playerDirection = Direction.neutral
    private var playerOnPlatform = false
    private var lastPlayerYPosition = CGFloat(0)
    
    private var cameraNode = Camera()
    
    private var jumpButton = SKSpriteNode()
    private var pauseButton = SKSpriteNode()
    
    private var scorePreview = SKLabelNode()
    private var lifeCountNode = SKSpriteNode()
    private var lifeLabel = SKLabelNode()
    private var slowCameraOverlay = SKSpriteNode()
    private var overlayInScene = false
    private var gamePaused = false
    
    private var sceneCentre: CGFloat?
    private var touchCount = 0
    
    private var background = Background()
    
    private var platformController = Platform()
    private var platformCameraDistance = CGFloat()
    
    private var panel: SKSpriteNode?
    
    override func didMove(to view: SKView)
    {
        
        physicsWorld.contactDelegate = self
        sceneCentre = (self.scene?.size.width)! / (self.scene?.size.height)!
        GameManager.sharedInstance.initialise()
        
        AudioManager.sharedInstance.ambientAudioVolume(inGame: true)
        
        initPlayer()
        initCamera()
        initBackground()
        initButtons()
        initStats()
        
        platformController.insertPlatforms(scene: self.scene!, player: player, isFirstPlatform: true)
        platformCameraDistance = (cameraNode.position.y - 400)
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        AudioManager.sharedInstance.checkQueue()
        managePlayer()
        manageCamera()
        manageBackground()
        managePlatforms()
        manageStats()
        
        if GameManager.sharedInstance.isGamePaused() && gamePaused == false
        {
            gamePaused = true
            pauseGame()
        }
        
        if GameManager.sharedInstance.isSlowCameraActive() == false && !overlayInScene
        {
            removeSlowCameraOverlay()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            switch (self.atPoint(location).name ?? "")
            {
                
                case "Jump":
                    
                    if playerOnPlatform
                    {
                        playerJumping = true
                        AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.jump)
                        
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                    }
                
                case "Pause":
                    
                    AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                    
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    GameManager.sharedInstance.pauseGame()
                
                case "Resume":
                    
                    AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                    
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    GameManager.sharedInstance.unPauseGame()
                    gamePaused = false
                    resumeGame()
                
                case "Restart":
                    
                    AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                    
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    GameManager.sharedInstance.unPauseGame()
                    DataManager.sharedInstance.gameState = GameState.new
                    reloadScene()
                
                case "Quit":
                    
                    AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.click)
                    
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    GameManager.sharedInstance.unPauseGame()
                    
                    if let scene = MenuScene(fileNamed: "MenuScene")
                    {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        
                        // Present the scene
                        self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.6))
                    }
                
                default:
                    
                    if !(self.scene?.isPaused)!
                    {
                        touchCount += 1
                        if location.x < sceneCentre!
                        {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            playerDirection = Direction.left
                        }
                        else if location.x > sceneCentre!
                        {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            playerDirection = Direction.right
                        }
                    }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            if self.atPoint(location).name != "Jump Button"
            {
                if touchCount > 1
                {
                    touchCount -= 1
                }
                else
                {
                    touchCount -= 1
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        var firstNode = SKPhysicsBody()
        var secondNode = SKPhysicsBody()
        
        if contact.bodyA.node?.physicsBody?.categoryBitMask == BitMask.Player
        {
            firstNode = contact.bodyA
            secondNode = contact.bodyB
        }
        else
        {
            firstNode = contact.bodyB
            secondNode = contact.bodyA
        }
        
        if firstNode.node?.physicsBody?.categoryBitMask == BitMask.Player && secondNode.node?.physicsBody?.categoryBitMask == BitMask.Platform
        {
            playerOnPlatform = true
        }
        else if firstNode.node?.physicsBody?.categoryBitMask == BitMask.Player && secondNode.node?.physicsBody?.categoryBitMask == BitMask.Collectable
        {
            if secondNode.node?.name == "Life"
            {
                AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.lifeCollectable)
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                GameManager.sharedInstance.increaseLife()
                secondNode.node?.removeFromParent()
                removeCollectables(collectableToRemove: Collectables.life)
            }
            else if secondNode.node?.name == "Slow Camera"
            {
                AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.slowCameraCollectable)
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                GameManager.sharedInstance.applySlowCamera()
                insertSlowCameraOverlay()
                secondNode.node?.removeFromParent()
                removeCollectables(collectableToRemove: Collectables.slowCamera)
            }
        }
        else if firstNode.node?.physicsBody?.categoryBitMask == BitMask.Player && secondNode.node?.physicsBody?.categoryBitMask == BitMask.Enemy
        {
            playerOnPlatform = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact)
    {
        var firstNode = SKPhysicsBody()
        var secondNode = SKPhysicsBody()
        
        if contact.bodyA.node?.physicsBody?.categoryBitMask == BitMask.Player
        {
            firstNode = contact.bodyA
            secondNode = contact.bodyB
        }
        else
        {
            firstNode = contact.bodyB
            secondNode = contact.bodyA
        }
        
        if firstNode.node?.physicsBody?.categoryBitMask == BitMask.Player && secondNode.node?.physicsBody?.categoryBitMask == BitMask.Platform
        {
            playerOnPlatform = false
        }
        
        if firstNode.node?.physicsBody?.categoryBitMask == BitMask.Player && secondNode.node?.physicsBody?.categoryBitMask == BitMask.Enemy
        {
            playerOnPlatform = false
            removeEnemyPlatform(enemyPlatform: secondNode.node as! SKSpriteNode)
            
        }
    }
    
    private func initPlayer()
    {
        player = Player(texture: SKTexture(image: #imageLiteral(resourceName: "Player")))
        player.initialise()
        player.position = CGPoint(x: -310, y: -574)
        self.addChild(player)
    }
    
    private func initCamera()
    {
        switch DataManager.sharedInstance.getDifficulty()
        {
            case .easy:
                cameraNode.initialise(yAcceleration: 0.001, startingSpeed: 1.5, maxSpeed: 4.0)
            case .medium:
                cameraNode.initialise(yAcceleration: 0.002, startingSpeed: 2.0, maxSpeed: 6.0)
            case .hard:
                cameraNode.initialise(yAcceleration: 0.003, startingSpeed: 2.5, maxSpeed: 8.0)
        }
        
        self.addChild(cameraNode)
        self.camera = cameraNode
    }
    
    private func initBackground()
    {
        background.initMove(targetScene: self.scene!)
    }
    
    private func initButtons()
    {
        
        jumpButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Jump Button")))
        jumpButton.name = "Jump"
        jumpButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        jumpButton.position = CGPoint(x: 0, y: -572)
        jumpButton.zPosition = 5
        cameraNode.addChild(jumpButton)
        
        pauseButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Pause Button")))
        pauseButton.name = "Pause"
        pauseButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pauseButton.position = CGPoint(x: 300, y: -585)
        pauseButton.zPosition = 5
        cameraNode.addChild(pauseButton)
    }
    
    private func initStats()
    {
        lifeCountNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Life Count")))
        lifeCountNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        lifeCountNode.position = CGPoint(x: -260, y: 550)
        lifeCountNode.zPosition = 5
        
        lifeLabel = SKLabelNode()
        lifeLabel.fontName = "SF UI Display Regular"
        lifeLabel.fontSize = 48
        lifeLabel.position = CGPoint(x: -190, y: 515)
        lifeLabel.zPosition = 5
        
        scorePreview = SKLabelNode()
        scorePreview.fontName = "SF UI Display Regular"
        scorePreview.fontSize = 48
        scorePreview.position = CGPoint(x: 190, y: 515)
        scorePreview.zPosition = 5
        
        slowCameraOverlay = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Slow Camera Overlay")))
        slowCameraOverlay.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        slowCameraOverlay.position = CGPoint(x: 0, y: 604)
        slowCameraOverlay.zPosition = 5
        
        cameraNode.addChild(lifeCountNode)
        cameraNode.addChild(lifeLabel)
        cameraNode.addChild(scorePreview)
    }
    
    private func managePlayer()
    {
        let maxYPosition = CGFloat(717)
        let minYPosition = CGFloat(-717)
        
        let playerCameraPositon = convert(player.position, to: cameraNode)
        
        player.move(playerDirection: playerDirection)
        
        if playerJumping
        {
            player.jump()
            playerJumping = false
        }
        
        if playerCameraPositon.y < minYPosition
        {
            killPlayer(playerVisible: false)
        }
        
        if playerCameraPositon.y > maxYPosition
        {
            killPlayer(playerVisible: false)
        }
        
        if playerOnPlatform
        {
            player.changeState(newState: State.normal)
        }
        else if (player.physicsBody?.velocity.dy)! > CGFloat(0)
        {
            player.changeState(newState: State.effort)
        }
        else if (player.physicsBody?.velocity.dy)! < CGFloat(0)
        {
            player.changeState(newState: State.distress)
        }
    }
    
    private func manageCamera()
    {
        cameraNode.move()
    }
    
    private func manageBackground()
    {
        background.move(camera: cameraNode)
    }
    
    private func managePlatforms()
    {
        if platformCameraDistance < cameraNode.position.y
        {
            platformCameraDistance = cameraNode.position.y + 400
            
            platformController.insertPlatforms(scene: self.scene!, player: player, isFirstPlatform: false)
        }
        
        checkNodesVisible()
    }
    
    private func manageStats()
    {
        if player.position.y > lastPlayerYPosition
        {
            GameManager.sharedInstance.increaseScore()
            lastPlayerYPosition = player.position.y
        }
        
        scorePreview.text = "\(GameManager.sharedInstance.getScore())m"
        lifeLabel.text = "×\(GameManager.sharedInstance.getLifeCount())"
    }
    
    private func insertSlowCameraOverlay()
    {
        cameraNode.addChild(slowCameraOverlay)
    }
    
    private func removeSlowCameraOverlay()
    {
        if slowCameraOverlay.parent != nil
        {
            overlayInScene = true
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let fadeIn = SKAction.fadeIn(withDuration: 0.2)
            let soundEffect = SKAction.run
            {
                AudioManager.sharedInstance.audioQueue.enQueue(effect: SoundEffect.slowCameraEnded)
            }
            
            slowCameraOverlay.run(SKAction.sequence([(SKAction.repeat(SKAction.sequence([fadeOut, fadeIn]), count: 2)), fadeOut, soundEffect, SKAction.removeFromParent()]))
        }
    }
    
    private func removeEnemyPlatform(enemyPlatform: SKSpriteNode)
    {
        let reduceAlpha = SKAction.fadeAlpha(to: 0, duration: 0.3)
        let scaleOut = SKAction.scale(to: 0, duration: 0.7)
        
        enemyPlatform.run(SKAction.sequence([reduceAlpha, scaleOut, SKAction.removeFromParent()]))
    }
    
    private func killPlayer(playerVisible: Bool)
    {
        self.scene?.isPaused = true
        GameManager.sharedInstance.decreaseLife()
        
        if playerVisible
        {
            player.removeFromParent()
        }
        
        endGame()
    }
    
    private func endGame()
    {
        if GameManager.sharedInstance.getLifeCount() >= 0
        {
            DataManager.sharedInstance.gameState = GameState.restarted
            reloadScene()
        }
        else
        {
            DataManager.sharedInstance.gameState = GameState.new
            GameManager.sharedInstance.checkHighScore()
            showPanel(gameEnded: true)
        }
    }
    
    private func reloadScene()
    {
        if let scene = GameScene(fileNamed: "GameScene")
        {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.6))
        }
    }
    
    private func checkNodesVisible()
    {
        for child in children
        {
            if child.position.y < cameraNode.position.y - (self.scene?.size.height)!
            {
                if child.name != "Background"
                {
                    child.removeFromParent()
                }
            }
        }
    }
    
    private func removeCollectables(collectableToRemove: Collectables)
    {
        self.scene?.enumerateChildNodes(withName: collectableToRemove.rawValue, using: (
            {
                (node, error) in
                
                node.removeFromParent()
        }))
    }
    
    func pauseGame()
    {
        pauseButton.isHidden = true
        self.scene?.isPaused = true
        showPanel(gameEnded: false)
    }
    
    func resumeGame()
    {
        panel?.removeFromParent()
        pauseButton.isHidden = false
        self.scene?.isPaused = false
    }
    
    private func showPanel(gameEnded: Bool)
    {
        panel = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Panel")))
        panel?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        panel?.zPosition = 6
        panel?.position = CGPoint(x: 0, y: 0)
        
        let restartButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Restart Button")))
        restartButton.name = "Restart"
        restartButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        restartButton.zPosition = 7
        
        let restartLabel = SKLabelNode()
        restartLabel.name = "Restart"
        restartLabel.fontName = "SF UI Display Regular"
        restartLabel.fontSize = 32
        restartLabel.text = "Restart"
        restartLabel.zPosition = 7
        
        let quitButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Quit Button")))
        quitButton.name = "Quit"
        quitButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quitButton.zPosition = 7
        
        let quitLabel = SKLabelNode()
        quitLabel.name = "Quit"
        quitLabel.fontName = "SF UI Display Regular"
        quitLabel.fontSize = 32
        quitLabel.text = "Quit"
        quitLabel.zPosition = 7
        
        if gameEnded
        {
            let scoreLabel = SKLabelNode()
            scoreLabel.fontName = "SF UI Display Regular"
            scoreLabel.fontSize = 32
            scoreLabel.position = CGPoint(x: 0, y: 250)
            scoreLabel.text = "Distance"
            scoreLabel.zPosition = 7
            panel?.addChild(scoreLabel)
            
            let finalScoreLabel = SKLabelNode()
            finalScoreLabel.fontName = "SF UI Display Regular"
            finalScoreLabel.fontSize = 64
            finalScoreLabel.position = CGPoint(x: 0, y: 175)
            finalScoreLabel.zPosition = 7
            finalScoreLabel.text = "\(GameManager.sharedInstance.getScore())m"
            panel?.addChild(finalScoreLabel)
            
            if GameManager.sharedInstance.isHighScore()
            {
                scoreLabel.text = "New Best Distance"
                finalScoreLabel.text = "\(GameManager.sharedInstance.getScore())m!"
            }
            
            restartButton.position = CGPoint(x: 125, y: 50)
            restartLabel.position = CGPoint(x: 125, y: -55)
            quitButton.position = CGPoint(x: -125, y: 50)
            quitLabel.position = CGPoint(x: -125, y: -55)
            
            scorePreview.removeFromParent()
            lifeCountNode.removeFromParent()
            lifeLabel.removeFromParent()
        }
        else
        {
            let resumeButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Play Button")))
            resumeButton.name = "Resume"
            resumeButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            resumeButton.zPosition = 7
            resumeButton.position = CGPoint(x: 0, y: 50)
            panel?.addChild(resumeButton)
            
            let resumeLabel = SKLabelNode()
            resumeLabel.name = "Resume"
            resumeLabel.fontName = "SF UI Display Regular"
            resumeLabel.fontSize = 32
            resumeLabel.position = CGPoint(x: 0, y: -55)
            resumeLabel.zPosition = 7
            resumeLabel.text = "Resume"
            panel?.addChild(resumeLabel)
            
            restartButton.position = CGPoint(x: 125, y: 226)
            restartLabel.position = CGPoint(x: 125, y: 121)
            quitButton.position = CGPoint(x: -125, y: 226)
            quitLabel.position = CGPoint(x: -125, y: 121)
        }
        
        panel?.addChild(restartButton)
        panel?.addChild(restartLabel)
        panel?.addChild(quitButton)
        panel?.addChild(quitLabel)
        
        cameraNode.addChild(panel!)
    }
}
