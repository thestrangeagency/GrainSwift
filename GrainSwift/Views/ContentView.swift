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
            
            if let buffer = audio.source?.audioBuffer {
                WaveView(buffer: buffer, position: audio.grainControl.position)
                GrainView(
                    position: audio.grainControl.position,
                    size: audio.grainControl.size,
                    positionJitter: audio.grainControl.positionJitter,
                    sizeJitter: audio.grainControl.sizeJitter,
                    ramp: audio.grainControl.ramp)
            }
            
            ControlSliderView(name: "density", value: $audio.grainControl.density)
            
            ControlTwinSliderView(name: "size", valueOne: $audio.grainControl.size, valueTwo: $audio.grainControl.sizeJitter)
            ControlTwinSliderView(name: "position", valueOne: $audio.grainControl.position, valueTwo: $audio.grainControl.positionJitter)
            ControlTwinSliderView(name: "spread", valueOne: $audio.grainControl.spread, valueTwo: $audio.grainControl.spreadJitter)
            
            ControlSliderView(name: "ramp", value: $audio.grainControl.ramp)
        }
    }
}

struct ControlSliderView: View {
    let name: String
    @Binding var value: Double
    
    var body: some View {
        VStack {
            Text("\(name): \(value)")
            
            Slider(value: $value, in: 0...1, step: 0.001)
                .padding()
        }
    }
}

struct ControlTwinSliderView: View {
    let name: String
    @Binding var valueOne: Double
    @Binding var valueTwo: Double
    
    var body: some View {
        VStack {
            Text("\(name): \(valueOne) | \(valueTwo)")
            
            HStack {
                Slider(value: $valueOne, in: 0...1, step: 0.001)
                    .padding()
                Slider(value: $valueTwo, in: 0...1, step: 0.001)
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Audio())
    }
}
