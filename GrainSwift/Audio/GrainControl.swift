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
    
    // MARK: - envelope
    
    var ampAttackTime: Double {
        get {
            return Grain.env1.attackTime / maxAttackTime
        }
        set {
            Grain.env1.attackTime = newValue * maxAttackTime
            objectWillChange.send()
        }
    }
    
    var ampReleaseTime: Double {
        get {
            return Grain.env1.releaseTime / maxReleaseTime
        }
        set {
            Grain.env1.releaseTime = newValue * maxReleaseTime
            objectWillChange.send()
        }
    }
    
    var ampHold: Bool {
        get {
            return Grain.env1.hold
        }
        set {
            Grain.env1.hold = newValue
        }
    }
    
    func ampReset() {
        Grain.env1.reset()
    }
    
    func ampRelease() {
        Grain.env1.release()
    }
    
    // MARK: - env1
    
    var env1Position: Double {
        get {
            return Grain.env1Index
        }
        set {
            Grain.env1Index = newValue
            objectWillChange.send()
        }
    }
    
    var env1Size: Double {
        get {
            return Grain.env1Length
        }
        set {
            Grain.env1Length = newValue
            objectWillChange.send()
        }
    }
    
    var env1Spread: Double {
        get {
            return Grain.env1Delay
        }
        set {
            Grain.env1Delay = newValue
            objectWillChange.send()
        }
    }
    
    var env1Pitch: Double {
        get {
            return Grain.env1Pitch
        }
        set {
            Grain.env1Pitch = newValue
            objectWillChange.send()
        }
    }
    
    // MARK: - lfo1
    
    var lfo1Period: Double {
        get {
            return Double(Grain.lfo1.period) / maxPeriod
        }
        set {
            Grain.lfo1.period = Int(max(newValue * maxPeriod, minPeriod))
            objectWillChange.send()
        }
    }
    
    var lfo1Position: Double {
        get {
            return Grain.lfo1Index
        }
        set {
            Grain.lfo1Index = newValue
            objectWillChange.send()
        }
    }
    
    var lfo1Size: Double {
        get {
            return Grain.lfo1Length
        }
        set {
            Grain.lfo1Length = newValue
            objectWillChange.send()
        }
    }
    
    var lfo1Spread: Double {
        get {
            return Grain.lfo1Delay
        }
        set {
            Grain.lfo1Delay = newValue
            objectWillChange.send()
        }
    }
    
    var lfo1Pitch: Double {
        get {
            return Grain.lfo1Pitch
        }
        set {
            Grain.lfo1Pitch = newValue
            objectWillChange.send()
        }
    }
    
    // MARK: - lfo2
    
    var lfo2Period: Double {
        get {
            return Double(Grain.lfo2.period) / maxPeriod
        }
        set {
            Grain.lfo2.period = Int(max(newValue * maxPeriod, minPeriod))
            objectWillChange.send()
        }
    }
    
    var lfo2Position: Double {
        get {
            return Grain.lfo2Index
        }
        set {
            Grain.lfo2Index = newValue
            objectWillChange.send()
        }
    }
    
    var lfo2Size: Double {
        get {
            return Grain.lfo2Length
        }
        set {
            Grain.lfo2Length = newValue
            objectWillChange.send()
        }
    }
    
    var lfo2Spread: Double {
        get {
            return Grain.lfo2Delay
        }
        set {
            Grain.lfo2Delay = newValue
            objectWillChange.send()
        }
    }
    
    var lfo2Pitch: Double {
        get {
            return Grain.lfo2Pitch
        }
        set {
            Grain.lfo2Pitch = newValue
            objectWillChange.send()
        }
    }

    // MARK: - grain
    
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
    
    // MARK: - global
    
    var volume: Double {
        get {
            return Grain.volume
        }
        set {
            let newValueClamped = clamp(newValue, minValue: 0, maxValue: 1)
            Grain.volume = newValueClamped
            objectWillChange.send()
        }
    }
    
    init() {
    }
}
