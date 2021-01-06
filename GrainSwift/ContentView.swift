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
        VStack {
            Text("Audio is \(audio.source?.loaded ?? false ? "loaded" : "not loaded")")
                .padding()
            
            Text("density: \(audio.grainControl.density)")
                .padding()
            
            Slider(value: $audio.grainControl.density, in: 0...1, step: 0.001)
                .padding()
            
            Text("size: \(audio.grainControl.size)")
                .padding()
            
            Slider(value: $audio.grainControl.size, in: 0...1, step: 0.001)
                .padding()
            
            Text("position \(audio.grainControl.position)")
                .padding()
            
            Slider(value: $audio.grainControl.position, in: 0...1, step: 0.001)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Audio())
    }
}
