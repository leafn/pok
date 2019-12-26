//
//  ProofOfKnowledge.swift
//  VotingApp
//
//  Created by leafN on 27/11/2019.
//  Copyright © 2019 leafN. All rights reserved.
//

import UIKit
import BigInt
import CryptoKit


class ProofOfKnowledge: NSObject {
    
    public static func messageMembership(
        _ m: (r: BigUInt, c: BigUInt),
        _ candidates: [BigUInt],
        _ pk: PaillierPublicKey,
        _ select: Int
    ) -> (v: [BigInt], e: [BigInt], u: [BigInt])? {
        
        let n = pk.n!
        let n2 = pk.n2!
        let g = pk.g!
        
        var k: BigUInt
        repeat {
            k = BigUInt.randomInteger(lessThan: n)
        } while (k == BigUInt(1))
        
        let p = candidates.count
        
        let r = m.r
        let c = m.c
        
        var e: [BigUInt] = []
        var v: [BigUInt] = []
        var u: [BigUInt] = []
        
        for _ in 0..<(p - 1) {
            e.append(BigUInt.randomInteger(lessThan: n))
            v.append(BigUInt.randomInteger(lessThan: n))
        }
        
        let u_i = k.power(n, modulus: n2)
        
        for i in 0..<p {
            var temp: BigUInt?
            var u_j: BigUInt?
            
            if i < select - 1 {
                temp = (g.power(candidates[i], modulus: n2) * (c.inverse(n2) ?? 0)).power(e[i], modulus: n2)
                u_j = (v[i].power(n, modulus: n2) * temp!).power(1, modulus: n2)
                u.append(u_j!)
            } else if i > select - 1 {
                temp = (g.power(candidates[i], modulus: n2) * (c.inverse(n2) ?? 0)).power(e[i - 1], modulus: n2)
                u_j = (v[i - 1].power(n, modulus: n2) * temp!).power(1, modulus: n2)
                u.append(u_j!)
            }
        }
        
        var sig_uk = BigUInt(0)
        var sig_ek = BigUInt(0)
        var sig_ek_mod_n = BigUInt(0)
        
        for i in 0..<(p - 1) {
            sig_uk = sig_uk + u[i]
            sig_ek = sig_ek + e[i]
            sig_ek_mod_n = sig_ek_mod_n + e[i].power(1, modulus: n)
        }
        
        let digest = SHA256.hash(data: sig_uk.serialize())
        let e_hash = BigUInt(Data(digest))
        let e_i = BigInt(e_hash) - BigInt(sig_ek_mod_n)
        
        
//        let e_hash = BigUInt(Data(digest))
//        let e_i = BigInt(e_hash) - BigInt(sig_ek_mod_n)
//
        
        let v_i = (BigInt(k.power(1, modulus: n)) * BigInt(r).power(e_i, modulus: BigInt(n))).power(1, modulus: BigInt(n)) * BigInt(g.power(0, modulus: n))
        //let v_i = (k.power(1, modulus: n) * r.power(BigUInt(e_i), modulus: n)).power(1, modulus: n) * g.power(0, modulus: n)

        var e_bigint = e.map({(v) -> BigInt in return BigInt(v)})
        var v_bigint = v.map({(v) -> BigInt in return BigInt(v)})
        var u_bigint = u.map({(v) -> BigInt in return BigInt(v)})
        
        v_bigint.insert(v_i, at: select - 1)
        e_bigint.insert(e_i, at: select - 1)
        u_bigint.insert(BigInt(u_i), at: select - 1)
        //
        
//        let e_bigint = e.map({(v) -> BigInt in return BigInt(v)})
//        let v_bigint = v.map({(v) -> BigInt in return BigInt(v)})
//        let u_bigint = u.map({(v) -> BigInt in return BigInt(v)})
        
        return (v_bigint, e_bigint, u_bigint)
//        var e_bigint = e.map({(v) -> BigInt in return BigInt(v)})
//        var v_bigint = e.map({(v) -> BigInt in return BigInt(v)})
//        var u_bigint = e.map({(v) -> BigInt in return BigInt(v)})
//
//        v_bigint.append(BigInt(v_i))
//        e_bigint.append(e_i)
//        u_bigint.append(BigInt(u_i))
//
//        return (v_bigint, e_bigint, u_bigint)
    }
    
    public class func decryptionCorrectness() {
        
    }
}
