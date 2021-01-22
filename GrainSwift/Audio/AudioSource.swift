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
    
    struct UserDefaultsKeys {
        static let lastFileUrl = "lastFileUrl"
    }

    init?() {
        guard let audioFileUrl = Bundle.main.url(forResource: "test", withExtension: "wav") else {
            return nil
        }
        
        // attempt to load previous url but default to bundle url
        if let previousUrl = UserDefaults.standard.url(forKey: UserDefaultsKeys.lastFileUrl) {
            print("attempting to load previous url \(previousUrl)")
            if !loadFileFrom(previousUrl) {
                if !loadFileFrom(audioFileUrl) {
                    return nil
                }
            }
        } else {
            if !loadFileFrom(audioFileUrl) {
                return nil
            }
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
            
            // save a copy for next time
            if let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let docFileUrl = docsUrl.appendingPathComponent("source.wav")
                if audioFileUrl != docFileUrl {
                    try? FileManager.default.removeItem(at: docFileUrl)
                    do {
                        try FileManager.default.copyItem(at: audioFileUrl, to: docFileUrl)
                        print("saved a local copy of source file")
                        UserDefaults.standard.set(docFileUrl, forKey: UserDefaultsKeys.lastFileUrl)
                    } catch {
                        print("error: failed to make a local copy of source file")
                    }
                }
            }
            
            return true
        } else {
            print("error: could not read file")
            return false
        }
    }
}
