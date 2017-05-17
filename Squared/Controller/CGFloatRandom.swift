//
//  CGFloatRandom.swift
//  Squared
//
//  Created by Conor McKillop on 08/05/2017.
//  Copyright © 2017 Conor McKillop. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat
{
    public static func randomFromRange(numA: CGFloat, numB: CGFloat) -> CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * Swift.abs(numA - numB) + numA
    }
}
