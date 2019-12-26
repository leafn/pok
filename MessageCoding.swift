//
//  MessageCoding.swift
//  VotingApp
//
//  Created by leafN on 02/12/2019.
//  Copyright © 2019 leafN. All rights reserved.
//

import UIKit
import BigInt

class MessageCoding: NSObject {
    static let max_p = 24
    
    public static func encode(_ p: Int, _ m: Int) -> BigUInt {
        if m < 0 || m > p {
            return BigUInt(0)
        }
        
        return BigUInt(beta(p + 1)).power(m);
    }
    
    public static func decode(_ sum: BigUInt, _ j: Int) -> BigUInt{
        let b = beta(max_p + 1)
        let sum = sum / BigUInt(b)
        let sx = sum / BigUInt(b).power(j - 1)
        let sj = sx.power(BigUInt(1), modulus: BigUInt(b))
        
        return sj
    }
    
    public static func beta(_ v: Int) -> Int{
        return 1 << v;
    }
}

