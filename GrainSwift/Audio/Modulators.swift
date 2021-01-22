//
//  Modulators.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/20/21.
//

import Foundation

protocol Modulator {
    var level: Double { get }
    mutating func reset()
    mutating func step()
}

protocol Envelope: Modulator {
    mutating func release()
}

enum EnvelopeStage {
    case attack
    case sustain
    case decay
    case release
}

struct ASREnvelope: Envelope {

    public var attackTime = 0.0
    public var releaseTime = 0.0
    
    var offset = 0.0
    var level = 0.0
    
    var stage = EnvelopeStage.decay
    
    mutating func reset() {
        offset = 0
        stage = .attack
    }
    
    mutating func release() {
        offset = 0
        stage = .release
    }
    
    mutating func step() {
        
        if stage == .attack {
            level = attackTime > 0 ? min(offset / attackTime, 1) : 1
            
            if offset >= attackTime {
                stage = .sustain
            }
        } else if stage == .release && level > 0.0 {
            level = releaseTime > 0 ? min(offset / releaseTime, 1) : 1
        }
        
        offset += 1
    }
}

