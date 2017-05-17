//
//  AudioQueue.swift
//  Squared
//
//  Created by Conor McKillop on 13/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import Foundation

// Event Queue Design Pattern
class AudioQueue
{
    private final let maxLength = 30
    
    private var array = [SoundEffect?](repeating: nil, count: 30)
    private var head = 0
    private var tail = 0
    
    func enQueue(effect: SoundEffect)
    {
        if !isFull() && !isDuplicate(effect: effect)
        {
            array[tail % array.count] = effect
            tail += 1
        }
    }
    
    func deQueue() -> SoundEffect?
    {
        if !isEmpty()
        {
            let effect = array[head % array.count]
            head += 1
            return effect
        }
        else
        {
            return nil
        }
    }
    
    func isFull() -> Bool
    {
        return array.count - (head - tail) == 0
    }
    
    func isEmpty() -> Bool
    {
        return (head - tail) == 0
    }
    
    private func isDuplicate(effect: SoundEffect) -> Bool
    {
        if !isEmpty()
        {
            for i in head...tail
            {
                if array[i] == effect
                {
                    return true
                }
                else
                {
                    return false
                }
            }
        }
        
        return false
    }
}
