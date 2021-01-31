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
                        .background(Style.colorFor(x: 0.15, y: audio.grainControl.ampHold ? 0.15 : 0.0))
                    PositionControlView(touching: $isTouchingPosition)
                }
                
                GrainView(
                    position: audio.grainControl.position,
                    size: audio.grainControl.size,
                    positionJitter: audio.grainControl.positionJitter,
                    sizeJitter: audio.grainControl.sizeJitter,
                    ramp: audio.grainControl.ramp,
                    spread: audio.grainControl.spread)
                    .background(Style.colorFor(x: 0.0, y: 0.25))
                    .padding()
            }
            
            HStack {
                XYControlView(label: "density", x: $audio.grainControl.density)
                XYControlView(label: "ramp", x: $audio.grainControl.ramp)
            }
            
            HStack {
                XYControlView(
                    label: "position",
                    x: $audio.grainControl.position,
                    y: $audio.grainControl.positionJitter,
                    zLabel: "env",
                    z: $audio.grainControl.env1Position,
                    onDrag: {
                        if !isTouchingPosition {
                            audio.grainControl.ampHold = true
                        }
                    }).opacity(audio.grainControl.ampHold ? 1.0 : 0.1)
                XYControlView(
                    label: "size",
                    x: $audio.grainControl.size,
                    y: $audio.grainControl.sizeJitter,
                    zLabel: "env",
                    z: $audio.grainControl.env1Size
                )
            }
            
            HStack {
                HStack {
                    LabelControlView(label: "lfo1", value: $audio.grainControl.lfo1Position)
                    LabelControlView(label: "lfo2", value: $audio.grainControl.lfo2Position)
                }.padding(.horizontal)
                HStack {
                    LabelControlView(label: "lfo1", value: $audio.grainControl.lfo1Position)
                    LabelControlView(label: "lfo2", value: $audio.grainControl.lfo2Position)
                }.padding(.horizontal)
            }
            
            HStack {
                XYControlView(
                    label: "spread",
                    x: $audio.grainControl.spread,
                    y: $audio.grainControl.spreadJitter,
                    zLabel: "lfo",
                    z: $audio.grainControl.lfo1Spread
                )
                XYControlView(
                    label: "pitch",
                    x: $audio.grainControl.pitch,
                    y: $audio.grainControl.pitchJitter,
                    zLabel: "lfo",
                    z: $audio.grainControl.lfo1Pitch
                )
            }
            
            HStack {
                XYControlView(label: "attack", x: $audio.grainControl.ampAttackTime)
                XYControlView(label: "release", x: $audio.grainControl.ampReleaseTime)
            }
            .disabled(audio.grainControl.ampHold)
            
            HStack {
                XYControlView(label: "lfo 1", x: $audio.grainControl.lfo1Period)
                XYControlView(label: "volume", x: $audio.grainControl.volume)
            }
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
                .font(.system(size: 10))
            
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
        VStack(spacing: -8) {
            Text("\(name): \(valueOne) | \(valueTwo)")
                .font(.system(size: 10))
            
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
