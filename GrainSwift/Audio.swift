//
//  Audio.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/2/21.
//

import Foundation
import AVFoundation

class Audio: ObservableObject {
    @Published var source = AudioSource()
    
    let engine = AVAudioEngine()
    var grainEngine: GrainEngine?
    
    init() {
        let mainMixer = engine.mainMixerNode
        let output = engine.outputNode
        let outputFormat = output.inputFormat(forBus: 0)
        let inputFormat = source?.audioFile.processingFormat
   
        if let sourceNode = createGrainNode() {
            engine.attach(sourceNode)
            engine.connect(sourceNode, to: mainMixer, format: inputFormat)
        }
        
        engine.connect(mainMixer, to: output, format: outputFormat)
        
        do {
            try engine.start()
            print("engine started")
        } catch {
            print("could not start engine: \(error)")
        }
    }
    
    func createGrainNode() -> AVAudioSourceNode? {
        guard let audioBuffer = self.source?.audioBuffer,
              let sourceData = audioBuffer.floatChannelData else {
            return nil
        }
        
        grainEngine = GrainEngine(withBuffer: sourceData, length: audioBuffer.frameLength, channels: audioBuffer.stride)
        
        if (grainEngine != nil) {
            return AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
                
                let bufferListPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
                
                for frame in 0..<Int(frameCount) {
                    let sample = self.grainEngine!.sample()
                    
                    for channel in 0..<bufferListPointer.count {
                        let outBuffer:UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(bufferListPointer[channel])
                        outBuffer[frame] = channel == 0 ? sample.x : sample.y
                    }
                }
                return noErr
            }
        } else {
            return nil
        }
    }

    func getDensity() -> Double {
        return grainEngine?.density ?? 0.0
    }
    
    func increaseDensity() -> Double {
        return grainEngine?.increaseDensity() ?? 0.0
    }
}
