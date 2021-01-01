//
//  ContentView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/1/21.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        Text("Hello, O World, O Earth!")
            .padding()
            .onAppear {
                if let audioFileUrl = Bundle.main.url(forResource: "test", withExtension: "wav") {
                    let audioFile:AVAudioFile? = try! AVAudioFile(forReading: audioFileUrl)
                    print("opened a file with sample rate: \(audioFile?.fileFormat.sampleRate ?? 0.0)")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
