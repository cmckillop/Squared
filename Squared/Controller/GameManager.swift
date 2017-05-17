//
//  GameManager.swift
//  Squared
//
//  Created by Conor McKillop on 09/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import SpriteKit

class GameManager
{
    // Singleton Design Pattern
    static let sharedInstance = GameManager()
    private init()  {   }
    
    private var score: Int = 0
    private var exactScore: Double = 0
    private var lifeCount: Int = 0
    private var newHighScore = false
    
    private var slowCameraActive = false
    private var gamePaused = false
    
    private var slowCameraTimer = Timer()
    private var timerStartDate = Double()
    private var timerInterval: Double = 15
    private var timerRemaining = Double()
    
    func initialise()
    {
        if DataManager.sharedInstance.gameState == GameState.new
        {
            score = 0
            exactScore = 0
            lifeCount = 3
        }
    }
    
    func increaseScore()
    {
        exactScore += 0.2
        score = Int(exactScore)
    }
    
    func increaseLife()
    {
        lifeCount += 1
    }
    
    func decreaseLife()
    {
        lifeCount -= 1
    }
    
    func applySlowCamera()
    {
        slowCameraActive = true
        
        timerStartDate = Date.timeIntervalSinceReferenceDate
        slowCameraTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(removeSlowCamera), userInfo: nil, repeats: false)
    }
    
    @objc private func removeSlowCamera()
    {
        self.slowCameraActive = false
    }
    
    private func restartSlowCamera()
    {
        slowCameraTimer = Timer.scheduledTimer(timeInterval: timerRemaining, target: self, selector: #selector(removeSlowCamera), userInfo: nil, repeats: false)
        
    }
    
    func pauseGame()
    {
        gamePaused = true
        
        slowCameraTimer.invalidate()
        let elapsedTime = Date.timeIntervalSinceReferenceDate - timerStartDate
        timerRemaining = timerInterval - elapsedTime
    }
    
    func unPauseGame()
    {
        gamePaused = false
        restartSlowCamera()
    }
    
    func slowCameraTimeRemaining() -> Double
    {
        let timeRemaining = slowCameraTimer.fireDate.timeIntervalSinceNow
        return timeRemaining
    }
    
    func getScore() -> Int
    {
        return self.score
    }
    
    func getLifeCount() -> Int
    {
        return self.lifeCount
    }
    
    func isSlowCameraActive() -> Bool
    {
        return self.slowCameraActive
    }
    
    func isHighScore() -> Bool
    {
        return self.newHighScore
    }
    
    func isGamePaused() -> Bool
    {
        return self.gamePaused
    }
    
    func checkHighScore()
    {
        switch DataManager.sharedInstance.getDifficulty()
        {
        case .easy:
            
            let highScore = DataManager.sharedInstance.getEasyScore()
            if self.score > highScore
            {
                DataManager.sharedInstance.setEasyScore(easyScore: self.score)
                newHighScore = true
            }
                
        case .medium:
            
            let highScore = DataManager.sharedInstance.getMediumScore()
            if self.score > highScore
            {
                DataManager.sharedInstance.setMediumScore(mediumScore: self.score)
                newHighScore = true
            }
            
        case .hard:
            
            let highScore = DataManager.sharedInstance.getHardScore()
            if self.score > highScore
            {
                DataManager.sharedInstance.setHardScore(hardScore: self.score)
                newHighScore = true
            }
        }
    }}
