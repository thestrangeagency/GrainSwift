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
            if !(audio.source?.loaded ?? true) {
                Text("Audio is not loaded")
                    .padding()
            }
            
            if let buffer = audio.source?.audioBuffer {
                var touching = false
                GeometryReader { geometry in
                    WaveView(buffer: buffer, position: audio.grainControl.position)
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged { value in
                                    if audio.grainControl.ampHold {
                                        audio.grainControl.ampHold = false
                                    }
                                    if !touching {
                                        touching = true
                                        audio.grainControl.ampReset()
                                    }
                                    audio.grainControl.position = Double(value.location.x / geometry.size.width)
                                }
                                .onEnded { _ in
                                    touching = false
                                    audio.grainControl.ampRelease()
                                }
                        )
                }
                GrainView(
                    position: audio.grainControl.position,
                    size: audio.grainControl.size,
                    positionJitter: audio.grainControl.positionJitter,
                    sizeJitter: audio.grainControl.sizeJitter,
                    ramp: audio.grainControl.ramp)
            }
            
            ControlSliderView(name: "density", value: $audio.grainControl.density)
            ControlTwinSliderView(name: "spread", valueOne: $audio.grainControl.spread, valueTwo: $audio.grainControl.spreadJitter)
            ControlSliderView(name: "ramp", value: $audio.grainControl.ramp)
            
            ControlTwinSliderView(name: "size", valueOne: $audio.grainControl.size, valueTwo: $audio.grainControl.sizeJitter)
            ControlTwinSliderView(name: "position", valueOne: $audio.grainControl.position, valueTwo: $audio.grainControl.positionJitter)
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
