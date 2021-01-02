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
    var bufferIndex:AVAudioFrameCount = 0
    
    init() {
        let mainMixer = engine.mainMixerNode
        let output = engine.outputNode
        let outputFormat = output.inputFormat(forBus: 0)
        let inputFormat = source?.audioFile.processingFormat
   
        let sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            
            guard let audioBuffer = self.source?.audioBuffer,
                  let sourceData = audioBuffer.floatChannelData else {
                return noErr
            }
            
            let sourceChannelMax = audioBuffer.stride - 1
            let bufferListPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)

            for frame in 0..<Int(frameCount) {
                
                for channel in 0..<bufferListPointer.count {
                    let outBuffer:UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(bufferListPointer[channel])
                    outBuffer[frame] = sourceData[min(channel, sourceChannelMax)][Int(self.bufferIndex)]
                }
                
                self.bufferIndex = (self.bufferIndex + 1) % audioBuffer.frameLength
            }
            return noErr
        }
        
        engine.attach(sourceNode)
        engine.connect(sourceNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: output, format: outputFormat)
        
        do {
            try engine.start()
            print("engine started")
        } catch {
            print("could not start engine: \(error)")
        }
    }
}
