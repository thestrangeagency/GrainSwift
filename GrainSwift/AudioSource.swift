//
//  AudioSource.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/2/21.
//

import Foundation
import AVFoundation

struct AudioSource {
    var audioFile: AVAudioFile?
    var audioBuffer: AVAudioPCMBuffer?
    var loaded:Bool = false
    
    init?() {
        guard let audioFileUrl = Bundle.main.url(forResource: "test", withExtension: "wav") else {
            return nil
        }
        
        if !loadFileFrom(audioFileUrl) {
            return nil
        }
    }
 
    mutating func loadFileFrom(_ audioFileUrl: URL) -> Bool {
        loaded = false
        
        // open audio file
        do {
            try audioFile = AVAudioFile(forReading: audioFileUrl, commonFormat: .pcmFormatFloat32, interleaved: false)
            print("opened a file with sample rate: \(audioFile!.fileFormat.sampleRate) channels: \(audioFile!.fileFormat.channelCount)")
        } catch {
            print("error: could not open file for reading")
            return false
        }

        // read entire audio file into the buffer
        if let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile!.processingFormat, frameCapacity: AVAudioFrameCount(audioFile!.length)),
           ((try? audioFile!.read(into: audioBuffer)) != nil) {
            print("read file into buffer")
            self.audioBuffer = audioBuffer
            loaded = true
            return true
        } else {
            print("error: could not read file")
            return false
        }
    }
}
