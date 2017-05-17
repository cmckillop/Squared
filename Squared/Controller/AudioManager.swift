//
//  AudioManager.swift
//  Squared
//
//  Created by Conor McKillop on 08/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import AVFoundation
import UIKit
import SpriteKit

enum SoundEffect
{
    case click
    case jump
    case lifeCollectable
    case slowCameraCollectable
    case slowCameraEnded
}

class AudioManager
{
    // Singleton Design Pattern
    static let sharedInstance = AudioManager()
    private init()  {   }
    
    var audioQueue = AudioQueue()
    private var effectPlayer: AVAudioPlayer?
    private var backgroundPlayer: AVAudioPlayer?
    
    func checkQueue()
    {
        // Play audio effects in queue
        if !audioQueue.isEmpty()
        {
            playEffect(effect: audioQueue.deQueue()!)
        }
    }
    
    private func playEffect(effect: SoundEffect)
    {
        // Run processing in background dispatch queue to prevent hanging in the main thread
        DispatchQueue.global(qos: .background).async
        {
            var audioAsset: NSDataAsset?
            
            switch effect
            {
            case .click:
                audioAsset = NSDataAsset(name: "Click Sound")
            case .jump:
                audioAsset = NSDataAsset(name: "Jump Sound")
            case .lifeCollectable:
                audioAsset = NSDataAsset(name: "Life Sound")
            case .slowCameraCollectable:
                audioAsset = NSDataAsset(name: "Slow Camera Started")
            case .slowCameraEnded:
                audioAsset = NSDataAsset(name: "Slow Camera Ended")
            }
            
            do
            {
                self.effectPlayer = try AVAudioPlayer(data: (audioAsset?.data)!, fileTypeHint: "caf")
                self.effectPlayer?.numberOfLoops = 0
                self.effectPlayer?.prepareToPlay()
                self.effectPlayer?.play()
            }
            catch _ as NSError
            {
            }

        }
    }
    
    func initEffectPlayer()
    {
        if let initAsset = NSDataAsset(name:"Player Initialiser")
        {
            do
            {
                effectPlayer = try AVAudioPlayer(data: initAsset.data, fileTypeHint: "m4a")
                effectPlayer?.numberOfLoops = 0
                effectPlayer?.prepareToPlay()
                effectPlayer?.play()
            }
            catch _ as NSError
            {
            }
        }
    }
    
    func playAmbientAudio()
    {
        // Accessing Audio Files in Asset Catalog: https://developer.apple.com/library/content/qa/qa1913/_index.html
        if let ambientAudio = NSDataAsset(name:"Ambient Audio")
        {
            do
            {
                backgroundPlayer = try AVAudioPlayer(data: ambientAudio.data, fileTypeHint: "caf")
                backgroundPlayer?.numberOfLoops = -1
                backgroundPlayer?.prepareToPlay()
                backgroundPlayer?.volume = 0.1
                backgroundPlayer?.play()
                backgroundPlayer?.setVolume(0.6, fadeDuration: 2)
            }
            catch _ as NSError
            {
            }
        }
    }
    
    func ambientAudioVolume(inGame: Bool)
    {
        if backgroundPlayer?.isPlaying != nil
        {
            if inGame
            {
                backgroundPlayer?.setVolume(0.2, fadeDuration: 1.5)
            }
            else
            {
                backgroundPlayer?.setVolume(0.6, fadeDuration: 1.5)
            }
        }
    }
    
    func stopAmbientAudio()
    {
        if backgroundPlayer?.isPlaying != nil
        {
            backgroundPlayer?.stop()
        }
    }
    
    func isPlayerInitialised() -> Bool
    {
        return backgroundPlayer == nil
    }
    
}
