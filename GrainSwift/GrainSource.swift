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
    
    init() {
        
    }
}

struct Grain {
    static var buffer: UnsafePointer<UnsafeMutablePointer<Float>>?
    static var bufferLength: AVAudioFrameCount = 0
    static var bufferIndex: AVAudioFrameCount = 0
    static var bufferMaxChannel: Int = 1
    static var length: AVAudioFrameCount = 0
    static var grains:ContiguousArray<Grain> = ContiguousArray(repeating: Grain(), count: 10_000)
    static var grainCount = 0
    static var density = 0.1
    
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
