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
    var loaded:Bool = false;
    
    init?() {
        guard let audioFileUrl = Bundle.main.url(forResource: "test", withExtension: "wav") else {
            return nil
        }

        // open audio file
        do {
            try audioFile = AVAudioFile(forReading: audioFileUrl)
            print("opened a file with sample rate: \(audioFile.fileFormat.sampleRate)")
        } catch {
            print("error: could not open file for reading")
            return nil
        }

        guard let optionalAudioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
            return nil
        }

        // read entire audio file into a buffer
        audioBuffer = optionalAudioBuffer
        do {
            try audioFile.read(into: audioBuffer)
            print("read file into buffer")
            loaded = true
        } catch {
            print("error: could not read file")
            return nil
        }
    }
}
