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

    public var attackTime: UInt32 = 0
    public var releaseTime: UInt32 = 0
    
    var offset: UInt32 = 0
    var stage = EnvelopeStage.decay
    var level = 0.0

    init () {
        level = 0
    }
    
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
            level = min(Double(offset) / Double(attackTime), 1)
            
            if offset >= attackTime {
                stage = .sustain
            }
        } else if stage == .release && level > 0.0 {
            level = Double(offset) / Double(releaseTime)
        }
        
        offset += 1
    }
}

