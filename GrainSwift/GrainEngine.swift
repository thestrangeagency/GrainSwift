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
    static var buffer: UnsafePointer<UnsafeMutablePointer<Float>>?
    static var bufferLength: AVAudioFrameCount = 0
    static var bufferIndex: AVAudioFrameCount = 0
    static var bufferMaxChannel: Int = 1
    static var length: AVAudioFrameCount = 0
    
    var index:UInt32 = 0
    
    mutating func sample() -> SIMD2<Float> {

        guard let buffer = Self.buffer else {
            return SIMD2<Float>(0.0, 0.0)
        }
        
        let grainIndex:Int = Int((Self.bufferIndex + index) % Self.bufferLength)
        var sample = SIMD2<Float>(0.0, 0.0)
        
        sample.x = buffer[0][grainIndex]
        sample.y = buffer[max(0, Self.bufferMaxChannel)][grainIndex]
        
        index = (index + 1) % Self.length

        return sample
    }
}

struct GrainEngine {
    var grains:ContiguousArray<Grain> = ContiguousArray(repeating: Grain(), count: 20000)
    var grainCount = 0
    var density = 0.1
    
    init(withBuffer buffer:UnsafePointer<UnsafeMutablePointer<Float>>, length: AVAudioFrameCount, channels: Int = 2) {
        Grain.buffer = buffer
        Grain.bufferLength = length
        Grain.bufferIndex = length / 2
        Grain.bufferMaxChannel = channels - 1
        Grain.length = 44100 // arbitrary 0.1 seconds
    }
    
    mutating func increaseDensity() -> Double {
        density += 0.1
        density = min(density, 1.0)
        return density
    }
    
    mutating func sample() -> SIMD2<Float> {
        
        // spawn a new grain if count is below density
        if Double(grainCount) < density * Double(grains.count) {
            grainCount += 1
        }
        
        let amplitude = 1.0 / Float(grainCount)
        
        // iterate over grains and accumulate samples
        let sample = grains.withUnsafeMutableBufferPointer { buffer -> SIMD2<Float> in
            var result = SIMD2<Float>(0.0, 0.0)
            for i in 0..<grainCount {
                result += buffer[i].sample()
            }
            return result
        }

        return sample * amplitude
    }
}
