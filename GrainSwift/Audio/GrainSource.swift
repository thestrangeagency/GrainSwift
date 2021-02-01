//
//  GrainEngine.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/3/21.
//

import Foundation
import simd
import AVFoundation

struct Grain {
    // global grain parameters
    static var buffer: AVAudioPCMBuffer?                            // source buffer
    static var data: UnsafePointer<UnsafeMutablePointer<Float>>?    // source buffer data
    static var grains:ContiguousArray<Grain> = ContiguousArray(repeating: Grain(), count: 2_000)
    
    static var bufferLength: AVAudioFrameCount = 0  // source buffer length
    static var bufferIndex: AVAudioFrameCount = 0   // position in source buffer
    static var bufferMaxChannel: Int = 1            // 0 for mono, 1 for stereo
    
    static var length: AVAudioFrameCount = 0        // length of the grains
    static var delay: AVAudioFrameCount = 0         // delay between grains
    static var ramp: AVAudioFrameCount = 0          // length of attack and decay
    static var pitch: Double = 1.0                  // playback speed
    
    static var lengthJitter:UInt32 = 0              // add randomness to parameters
    static var indexJitter:UInt32 = 0
    static var delayJitter:UInt32 = 0
    static var pitchJitter:Double = 0.0
    
    static var grainCount = 0   // number of grains playing
    static var density = 0.1    // fraction of total count that should be playing
    
    static var volume = 1.0     // final volume multiplier
    
    static var env1 = ASREnvelope()
    static var lfo1 = LFO()
    static var lfo2 = LFO()
    
    // mod matrix
    static var lfo1Length = 0.0
    static var lfo1Delay = 0.0
    static var lfo1Index = 0.0
    static var lfo1Pitch = 0.0
    static var lfo1Volume = 0.0
    
    static var lfo2Length = 0.0
    static var lfo2Delay = 0.0
    static var lfo2Index = 0.0
    static var lfo2Pitch = 0.0
    static var lfo2Volume = 0.0
    
    static var env1Length = 0.0
    static var env1Delay = 0.0
    static var env1Index = 0.0
    static var env1Pitch = 0.0
    static var env1Volume = 1.0

    // per grain state
    var smoothOffset = 0.0  // current grain position relative to position in source buffer
    var length:UInt32 = 0   // length of the grain
    var index:UInt32 = 0    // position in source buffer
    var delay:UInt32 = 0    // delay between loops
    var ramp:UInt32 = 0     // length of attack and decay
    var pitch:Double = 1.0  // playback speed
    
    mutating func sample() -> SIMD2<Float> {
        
        guard let data = Self.data else {
            return SIMD2<Float>(0.0, 0.0)
        }
        
        // quantize offset to nearest integer
        let offset = UInt32(smoothOffset)
        
        // update with global parameters at start or loop
        if offset == 0 {
            length = Self.length + UInt32.random(in: 0...Self.lengthJitter)
            index = Self.bufferIndex + UInt32.random(in: 0...Self.indexJitter)
            delay = Self.delay + UInt32.random(in: 0...Self.delayJitter)
            ramp = Self.ramp
            pitch = Self.pitch + Double.random(in: -Self.pitchJitter...Self.pitchJitter)
            
            // calculate lfo1 influence based on mod matrix and maximally half of the relevant quantity
            let lengthLfo1 = Self.lfo1Length * Self.lfo1.level * Double(Self.length) * 0.5
            let indexLfo1 = Self.lfo1Index * Self.lfo1.level * Double(Self.bufferLength) * 0.5
            let delayLfo1 = Self.lfo1Delay * Self.lfo1.level * Double(Self.length) * 0.5
            let pitchLfo1 = Self.lfo1Pitch * Self.lfo1.level

            // calculate lfo2 influence
            let lengthLfo2 = Self.lfo2Length * Self.lfo2.level * Double(Self.length) * 0.5
            let indexLfo2 = Self.lfo2Index * Self.lfo2.level * Double(Self.bufferLength) * 0.5
            let delayLfo2 = Self.lfo2Delay * Self.lfo2.level * Double(Self.length) * 0.5
            let pitchLfo2 = Self.lfo2Pitch * Self.lfo2.level
            
            // calculate env1 influence
            let lengthEnv1 = Self.env1Length * Self.env1.level * Double(Self.length) * 0.5
            let indexEnv1 = Self.env1Index * Self.env1.level * Double(Self.bufferLength) * 0.5
            let delayEnv1 = Self.env1Delay * Self.env1.level * Double(Self.length) * 0.5
            let pitchEnv1 = Self.env1Pitch * Self.env1.level

            length = UInt32(max(1, Int(length) + Int(lengthLfo1) + Int(lengthLfo2) + Int(lengthEnv1)))
            index = UInt32(max(0, Int(index) + Int(indexLfo1) + Int(indexLfo2) + Int(indexEnv1)))
            delay = UInt32(max(0, Int(delay) + Int(delayLfo1) + Int(delayLfo2) + Int(delayEnv1)))
            pitch += max(0, pitchLfo1 + pitchLfo2 + pitchEnv1)
        }
        
        let grainIndex:Int = Int((index + offset) % Self.bufferLength)
        var sample = SIMD2<Float>(0.0, 0.0)
        
        // delay phase for grain variation returns silence
        if delay <= offset {
            // populate sample from source buffer
            sample.x = data[0][grainIndex]
            sample.y = data[max(0, Self.bufferMaxChannel)][grainIndex]
            
            
            // calculate trapezoidal envelope
            let attackIndex = offset - delay
            let attackFraction = Float(attackIndex) / Float(ramp)
            
            let decayIndex = length - attackIndex
            let decayFraction = Float(decayIndex) / Float(ramp)
            
            // scale sample with envelope
            if attackFraction < 1.0 {
                sample *= attackFraction
            } else if decayFraction < 1.0 {
                sample *= decayFraction
            }
        }
        
        smoothOffset = (smoothOffset + pitch).truncatingRemainder(dividingBy: Double(length + delay))
        smoothOffset = max(smoothOffset, 0) // let's keep things positive
        
        return sample
    }
}

struct GrainSource {
    
    init(withBuffer buffer:AVAudioPCMBuffer) {
        Grain.buffer = buffer
        Grain.data = buffer.floatChannelData
        Grain.bufferLength = buffer.frameLength
        Grain.bufferIndex = buffer.frameLength / 2
        Grain.bufferMaxChannel = buffer.stride - 1
        Grain.length = 4410
        Grain.delay = 0
        Grain.ramp = Grain.length / 6
        
        Grain.env1.attackTime = 4410
        Grain.env1.releaseTime = 44100 / 3
        Grain.env1.hold = true
        
        Grain.lfo2.period = Grain.lfo1.period * 4 // just to be different
    }
    
    func getSourceNode() -> AVAudioSourceNode? {
        return AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            
            let bufferListPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            
            for frame in 0..<Int(frameCount) {
                let sample = self.sample()
                
                for channel in 0..<bufferListPointer.count {
                    let outBuffer:UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(bufferListPointer[channel])
                    outBuffer[frame] = channel == 0 ? sample.x : sample.y
                }
            }
            return noErr
        }
    }
    
    func sample() -> SIMD2<Float> {
        
        // spawn a new grain if count is below density
        let targetCount = Int(Grain.density * Double(Grain.grains.count))
        if Grain.grainCount < targetCount {
            Grain.grainCount += 1
        } else if Grain.grainCount > targetCount {
            Grain.grainCount = max(Grain.grainCount - 1, 0)
        }
        
        let amplitude = 1.0 / sqrt(Float(Grain.grainCount))
        
        // iterate over grains and accumulate samples
        let sample = Grain.grains.withUnsafeMutableBufferPointer { buffer -> SIMD2<Float> in
            var result = SIMD2<Float>(0.0, 0.0)
            for i in 0..<Grain.grainCount {
                result += buffer[i].sample()
            }
            return result
        }
        
        // advance modulators
        Grain.env1.step()
        Grain.lfo1.step()
        Grain.lfo2.step()
        
        let volume: Float = Float(Grain.volume - Grain.env1Volume * (1.0 - Grain.env1.level))
        return sample * (amplitude * volume)
    }
}
