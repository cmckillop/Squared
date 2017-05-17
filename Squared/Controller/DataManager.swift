//
//  DataManager.swift
//  Squared
//
//  Created by Conor McKillop on 08/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import Foundation
import SpriteKit

enum GameState
{
    case new
    case restarted
}

// Momento Design Pattern
class DataManager
{
    // Singleton Design Pattern
    static let sharedInstance = DataManager()
    private init()  {   }
    
    private var data = Data()
    
    var gameState: GameState?
    
    func initialise()
    {
        // If no data exists then set-up game with initial data
        if !(data.checkExists())
        {
            data = Data()
            
            data.setEasyScore(easyScore: 0)
            data.setMediumScore(mediumScore: 0)
            data.setHardScore(hardScore: 0)
            data.setDifficulty(difficulty: Difficulty.easy)
            data.setAudioStatus(audioStatus: true)
            
            data.set()
        }
        
        data.read()
    }
    
    // Getters
    func getEasyScore() -> Int
    {
        return (self.data.getEasyScore())
    }
    
    func getMediumScore() -> Int
    {
        return (self.data.getMediumScore())
    }
    
    func getHardScore() -> Int
    {
        return (self.data.getHardScore())
    }
    
    func getDifficulty() -> Difficulty
    {
        return (self.data.getDifficulty())
    }
    
    func getAudioStatus() -> Bool
    {
        return (self.data.getAudioStatus())
    }
    
    // Setters
    func setEasyScore(easyScore: Int)
    {
        self.data.setEasyScore(easyScore: easyScore)
        data.set()
    }
    
    func setMediumScore(mediumScore: Int)
    {
        self.data.setMediumScore(mediumScore: mediumScore)
        data.set()
    }
    
    func setHardScore(hardScore: Int)
    {
        self.data.setHardScore(hardScore: hardScore)
        data.set()
    }
    
    func setDifficulty(difficulty: Difficulty)
    {
        self.data.setDifficulty(difficulty: difficulty)
        data.set()
    }
    
    func setAudioStatus(isAudioOn: Bool)
    {
        self.data.setAudioStatus(audioStatus: isAudioOn)
        data.set()
    }

}
