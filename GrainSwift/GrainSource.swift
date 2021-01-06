//
//  GrainEngine.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/3/21.
//

import Foundation
import simd
import AVFoundation
import SwiftUI

final class GrainControl : ObservableObject {

    var density: Double {
        get {
            return Grain.density
        }
        set {
            Grain.density = clamp(newValue, minValue: 0.0, maxValue: 1.0)
            objectWillChange.send()
        }
    }
    
    var size: Double {
        get {
            return Double(Grain.length) / Double(Grain.bufferLength)
        }
        set {
            let newSize: AVAudioFrameCount = AVAudioFrameCount(newValue * Double(Grain.bufferLength))
            Grain.length = clamp(newSize, minValue: 441, maxValue: Grain.bufferLength)
            objectWillChange.send()
        }
    }
    
    var position: Double {
        get {
            return Double(Grain.bufferIndex) / Double(Grain.bufferLength)
        }
        set {
            let newPosition: AVAudioFrameCount = AVAudioFrameCount(newValue * Double(Grain.bufferLength))
            Grain.bufferIndex = clamp(newPosition, minValue: 0, maxValue: Grain.bufferLength-1)
            objectWillChange.send()
        }
    }
    
    init() {
        
    }
}

struct Grain {
    // global grain parameters
    static var buffer: UnsafePointer<UnsafeMutablePointer<Float>>?  // source buffer
    static var grains:ContiguousArray<Grain> = ContiguousArray(repeating: Grain(), count: 10_000)
    
    static var bufferLength: AVAudioFrameCount = 0  // source buffer length
    static var bufferIndex: AVAudioFrameCount = 0   // position in source buffer
    static var bufferMaxChannel: Int = 1            // 0 for mono, 1 for stereo
    static var length: AVAudioFrameCount = 0        // length of the grains
    
    static var grainCount = 0   // number of grains playing
    static var density = 0.1    // fraction of total count that should be playing
    
    // per grain state
    var offset:UInt32 = 0   // current grain position relative to position in source buffer
    var length:UInt32 = 0   // length of the grain
    var index:UInt32 = 0    // position in source buffer
    
    mutating func sample() -> SIMD2<Float> {

        guard let buffer = Self.buffer else {
            return SIMD2<Float>(0.0, 0.0)
        }
        
        let grainIndex:Int = Int((Self.bufferIndex + offset) % Self.bufferLength)
        var sample = SIMD2<Float>(0.0, 0.0)
        
        sample.x = buffer[0][grainIndex]
        sample.y = buffer[max(0, Self.bufferMaxChannel)][grainIndex]
        
        offset = (offset + 1) % Self.length

        return sample
    }
}

struct GrainSource {
    
    init(withBuffer buffer:UnsafePointer<UnsafeMutablePointer<Float>>, length: AVAudioFrameCount, channels: Int = 2) {
        Grain.buffer = buffer
        Grain.bufferLength = length
        Grain.bufferIndex = length / 2
        Grain.bufferMaxChannel = channels - 1
        Grain.length = 44100 // arbitrary 0.1 seconds
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
        if Double(Grain.grainCount) < Grain.density * Double(Grain.grains.count) {
            Grain.grainCount += 1
        } else {
            Grain.grainCount = max(Grain.grainCount - 1, 0)
        }
        
        let amplitude = 1.0 / Float(Grain.grainCount)
        
        // iterate over grains and accumulate samples
        let sample = Grain.grains.withUnsafeMutableBufferPointer { buffer -> SIMD2<Float> in
            var result = SIMD2<Float>(0.0, 0.0)
            for i in 0..<Grain.grainCount {
                result += buffer[i].sample()
            }
            return result
        }

        return sample * amplitude
    }
}
