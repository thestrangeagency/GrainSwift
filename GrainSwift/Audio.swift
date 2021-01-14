//
//  Audio.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/2/21.
//

import Foundation
import AVFoundation
import Combine

class Audio: ObservableObject {
    @Published var source = AudioSource()
    
    let engine = AVAudioEngine()
    
    var grainSource: GrainSource?
    var grainControl = GrainControl()
    var grainControlCancellable: AnyCancellable? = nil
    var sourceNode: AVAudioSourceNode?
    
    init() {
        // bubble nested Observable changes
        grainControlCancellable = grainControl.objectWillChange.sink { (_) in
            self.objectWillChange.send()
        }

        initGrainSource()
        startEngine()
    }
    
    func startEngine() {
        do {
            try engine.start()
            print("engine started")
        } catch {
            print("could not start engine: \(error)")
        }
    }
    
    func initGrainSource() {
        if let sourceNode = createGrainNode() {
            self.sourceNode = sourceNode
            let mainMixer = engine.mainMixerNode
            let inputFormat = source?.audioFile!.processingFormat

            engine.attach(sourceNode)
            engine.connect(sourceNode, to: mainMixer, format: inputFormat)
        }
    }
    
    func createGrainNode() -> AVAudioSourceNode? {
        guard let audioBuffer = self.source?.audioBuffer else {
            return nil
        }
        
        grainSource = GrainSource(withBuffer: audioBuffer)
        return grainSource?.getSourceNode()
    }
    
    func loadFileFrom(_ audioFileUrl: URL) {
        engine.stop()
        
        if var source = self.source, source.loadFileFrom(audioFileUrl) {
            
            // disconnect previous grain source node
            if let sourceNode = self.sourceNode {
                engine.disconnectNodeOutput(sourceNode)
                engine.detach(sourceNode)
            }
            
            // reinit grain source and start audio engine
            initGrainSource()
            startEngine()
        }
    }
}
