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
            
            ControlSliderView(name: "density", value: $audio.grainControl.density)
            ControlSliderView(name: "size", value: $audio.grainControl.size)
            ControlSliderView(name: "position", value: $audio.grainControl.position)
        }
    }
}

struct ControlSliderView: View {
    let name: String
    @Binding var value: Double
    
    var body: some View {
        VStack {
            Text("\(name): \(value)")
                .padding()
            
            Slider(value: $value, in: 0...1, step: 0.001)
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
