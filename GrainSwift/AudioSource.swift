//
//  AudioSource.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/2/21.
//

import Foundation
import AVFoundation

struct AudioSource {
    var audioFile: AVAudioFile;
    var audioBuffer: AVAudioPCMBuffer;
    
    init?() {
        if let audioFileUrl = Bundle.main.url(forResource: "test", withExtension: "wav") {
            do {
                try audioFile = AVAudioFile(forReading: audioFileUrl)
                print("opened a file with sample rate: \(audioFile.fileFormat.sampleRate)")
            } catch {
                print("error: could not open file for reading")
                return nil
            }
            if let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) {
                self.audioBuffer = audioBuffer
                do {
                    try audioFile.read(into: self.audioBuffer)
                    print("read file into buffer")
                } catch {
                    print("error: could not read file")
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
