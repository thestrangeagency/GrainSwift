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
    var grainEngine: GrainSource?
    
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
        
        grainEngine = GrainSource(withBuffer: sourceData, length: audioBuffer.frameLength, channels: audioBuffer.stride)
        return grainEngine?.getSourceNode()
    }
}
