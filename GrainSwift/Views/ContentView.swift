//
//  ContentView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/1/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audio: Audio
    @State var isTouchingPosition = false
    
    var body: some View {
        VStack {
            if !(audio.source?.loaded ?? true) {
                Text("Audio is not loaded")
                    .padding()
            }
            
            if let buffer = audio.source?.audioBuffer {
                ZStack {
                    WaveView(buffer: buffer)
                    PositionControlView(touching: $isTouchingPosition)
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
            ControlTwinSliderView(name: "position", valueOne: $audio.grainControl.position, valueTwo: $audio.grainControl.positionJitter, onDrag: {
                if !isTouchingPosition {
                    audio.grainControl.ampHold = true
                }
            } )
        }
    }
}

struct ControlSliderView: View {
    let name: String
    @Binding var value: Double
    var onDrag: (() -> Void)?
    
    var body: some View {
        VStack {
            Text("\(name): \(value)")
            
            Slider(value: $value, in: 0...1, step: 0.001)
                .onChange(of: value) { _ in
                    onDrag?()
                }
                .padding()
        }
    }
}

struct ControlTwinSliderView: View {
    let name: String
    @Binding var valueOne: Double
    @Binding var valueTwo: Double
    var onDrag: (() -> Void)?
    
    var body: some View {
        VStack {
            Text("\(name): \(valueOne) | \(valueTwo)")
            
            HStack {
                Slider(value: $valueOne, in: 0...1, step: 0.001)
                    .onChange(of: valueOne) { _ in
                        onDrag?()
                    }
                    .padding()
                Slider(value: $valueTwo, in: 0...1, step: 0.001)
                    .onChange(of: valueTwo) { _ in
                        onDrag?()
                    }
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
