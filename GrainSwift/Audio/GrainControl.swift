//
//  GrainControl.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/15/21.
//

import AVFoundation

final class GrainControl : ObservableObject {
    let maxSize = 44100.0
    let maxJitter = 11025.0
    
    let maxAttackTime = 44100.0 * 2
    let maxReleaseTime = 44100.0 * 2
    
    let minPeriod = 441.0
    let maxPeriod = 44100.0 * 10
    
    var ampAttackTime: Double {
        get {
            return Grain.amp.attackTime / maxAttackTime
        }
        set {
            Grain.amp.attackTime = newValue * maxAttackTime
            objectWillChange.send()
        }
    }
    
    var ampReleaseTime: Double {
        get {
            return Grain.amp.releaseTime / maxReleaseTime
        }
        set {
            Grain.amp.releaseTime = newValue * maxReleaseTime
            objectWillChange.send()
        }
    }
    
    var ampHold: Bool {
        get {
            return Grain.amp.hold
        }
        set {
            Grain.amp.hold = newValue
        }
    }
    
    func ampReset() {
        Grain.amp.reset()
    }
    
    func ampRelease() {
        Grain.amp.release()
    }
    
    var lfoPeriod: Double {
        get {
            return Double(Grain.lfo.period) / maxPeriod
        }
        set {
            Grain.lfo.period = Int(max(newValue * maxPeriod, minPeriod))
            objectWillChange.send()
        }
    }
    
    var lfoPosition: Double {
        get {
            return Grain.lfoIndex
        }
        set {
            Grain.lfoIndex = newValue
            objectWillChange.send()
        }
    }

    var lfoSize: Double {
        get {
            return Grain.lfoLength
        }
        set {
            Grain.lfoLength = newValue
            objectWillChange.send()
        }
    }

    var lfoSpread: Double {
        get {
            return Grain.lfoDelay
        }
        set {
            Grain.lfoDelay = newValue
            objectWillChange.send()
        }
    }

    var lfoPitch: Double {
        get {
            return Grain.lfoPitch
        }
        set {
            Grain.lfoPitch = newValue
            objectWillChange.send()
        }
    }

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
    
    var sizeJitter: Double {
        get {
            return Double(Grain.lengthJitter) / Double(maxJitter)
        }
        set {
            let newValueClamped = clamp(newValue, minValue: 0, maxValue: 1)
            Grain.lengthJitter = AVAudioFrameCount(newValueClamped * maxJitter)
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
    
    var positionJitter: Double {
        get {
            return Double(Grain.indexJitter) / Double(maxJitter)
        }
        set {
            let newValueClamped = clamp(newValue, minValue: 0, maxValue: 1)
            Grain.indexJitter = UInt32(newValueClamped * Double(maxJitter))
            objectWillChange.send()
        }
    }
    
    var spread: Double {
        get {
            return Double(Grain.delay) / maxSize
        }
        set {
            let newValueClamped = clamp(newValue, minValue: 0, maxValue: 1)
            Grain.delay = AVAudioFrameCount(newValueClamped * maxSize)
            objectWillChange.send()
        }
    }
    
    var spreadJitter: Double {
        get {
            return Double(Grain.delayJitter) / Double(maxJitter)
        }
        set {
            let newValueClamped = clamp(newValue, minValue: 0, maxValue: 1)
            Grain.delayJitter = AVAudioFrameCount(newValueClamped * maxJitter)
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
            let newValueClamped = clamp(newValue, minValue: 0, maxValue: 1)
            let newSize: AVAudioFrameCount = AVAudioFrameCount(newValueClamped * maxRamp)
            let maxSizeClamped = min(AVAudioFrameCount(maxRamp), Grain.bufferLength)
            Grain.ramp = clamp(newSize, minValue: 0, maxValue: maxSizeClamped)
            objectWillChange.send()
        }
    }
    
    var pitch: Double {
        get {
            return Grain.pitch / 2.0
        }
        set {
            let newValueClamped = clamp(newValue, minValue: 0, maxValue: 1)
            Grain.pitch = newValueClamped * 2
            objectWillChange.send()
        }
    }
    
    var pitchJitter: Double {
        get {
            return Grain.pitchJitter * 2.0
        }
        set {
            let newValueClamped = clamp(newValue, minValue: 0, maxValue: 1)
            Grain.pitchJitter = newValueClamped / 2
            objectWillChange.send()
        }
    }
    
    init() {
    }
}
