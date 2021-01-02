//
//  ContentView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/1/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audio: Audio
    
    var body: some View {
        Text("Audio is \(audio.source?.loaded ?? false ? "loaded" : "not loaded")")
            .padding()
            .environmentObject(audio)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Audio())
    }
}
