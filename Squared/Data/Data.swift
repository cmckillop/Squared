//
//  Data.swift
//  TestGame
//
//  Created by Conor McKillop on 08/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import Foundation

class Data
{
    private var easyScore = Int()
    private var mediumScore = Int()
    private var hardScore = Int()
    
    private var difficulty = String()
    
    private var audioStatus = false
    
    // Storing enum values in iOS UserDefaults http://stackoverflow.com/questions/28246174/
    
    func set()
    {
        let defaults = UserDefaults.standard
        defaults.set(easyScore, forKey: "EasyScore")
        defaults.set(mediumScore, forKey: "MediumScore")
        defaults.set(hardScore, forKey: "HardScore")
        defaults.set(difficulty, forKey: "Difficulty")
        defaults.set(audioStatus, forKey: "AudioStatus")
    }
    
    func read()
    {
        let defaults = UserDefaults.standard
        
        easyScore = defaults.integer(forKey: "EasyScore")
        mediumScore = defaults.integer(forKey: "MediumScore")
        hardScore = defaults.integer(forKey: "HardScore")
        if let readDifficulty = defaults.string(forKey: "Difficulty")
        {
            difficulty = readDifficulty
        }
        audioStatus = defaults.bool(forKey: "AudioStatus")
    }
    
    func checkExists() -> Bool
    {
        if (UserDefaults.standard.object(forKey: "EasyScore") != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // Getters
    func getEasyScore() -> Int
    {
        return self.easyScore
    }
    
    func getMediumScore() -> Int
    {
        return self.mediumScore
    }
    
    func getHardScore() -> Int
    {
        return self.hardScore
    }
    
    func getDifficulty() -> Difficulty
    {
        return Difficulty(rawValue: difficulty)!
    }
    
    func getAudioStatus() -> Bool
    {
        return self.audioStatus
    }
    
    // Setters
    func setEasyScore(easyScore: Int)
    {
        self.easyScore = easyScore
    }
    
    func setMediumScore(mediumScore: Int)
    {
        self.mediumScore = mediumScore
    }
    
    func setHardScore(hardScore: Int)
    {
        self.hardScore = hardScore
    }
    
    func setDifficulty(difficulty: Difficulty)
    {
        self.difficulty = difficulty.rawValue
    }
    
    func setAudioStatus(audioStatus: Bool)
    {
        self.audioStatus = audioStatus
    }
}
