//
//  GrainControl.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/15/21.
//

import AVFoundation

final class GrainControl : ObservableObject {
    let maxSize = 44100.0
    
    var density: Double {
        get {
            return Grain.density
        }
        set {
            Grain.density = clamp(newValue, minValue: 0.01, maxValue: 1.0)
            objectWillChange.send()
        }
    }
    
    var size: Double {
        get {
            return Double(Grain.length) / maxSize
        }
        set {
            let newSize: AVAudioFrameCount = AVAudioFrameCount(newValue * maxSize)
            let maxSizeClamped = min(AVAudioFrameCount(maxSize), Grain.bufferLength)
            Grain.length = clamp(newSize, minValue: 441, maxValue: maxSizeClamped)
            Grain.ramp = min(Grain.ramp, AVAudioFrameCount(maxRamp))
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
    
    var spread: Double {
        get {
            return Double(Grain.delay) / maxSize
        }
        set {
            let newSize: AVAudioFrameCount = AVAudioFrameCount(newValue * maxSize)
            let maxSizeClamped = min(AVAudioFrameCount(maxSize), Grain.bufferLength)
            Grain.delay = clamp(newSize, minValue: 441, maxValue: maxSizeClamped)
            objectWillChange.send()
        }
    }
    
    var maxRamp: Double {
        get {
            return Double(Grain.length) * 0.5
        }
    }
    
    var ramp: Double {
        get {
            return Double(Grain.ramp) / maxRamp
        }
        set {
            let newSize: AVAudioFrameCount = AVAudioFrameCount(newValue * maxRamp)
            let maxSizeClamped = min(AVAudioFrameCount(maxRamp), Grain.bufferLength)
            Grain.ramp = clamp(newSize, minValue: 0, maxValue: maxSizeClamped)
            objectWillChange.send()
        }
    }
    
    init() {
    }
}
