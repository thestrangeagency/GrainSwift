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
            
            // 1d controls get less height
            let shortHeight: CGFloat = 80.0
            
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
                    ramp: audio.grainControl.ramp,
                    spread: audio.grainControl.spread)
                    .background(Style.colorFor(x: audio.grainControl.ramp, y: 1.0 - audio.grainControl.density))
                    .frame(height: shortHeight * 0.666)
            }
            
            // position and size
            HStack(spacing: Style.margin) {
                XYControlView(
                    label: "position",
                    x: $audio.grainControl.position,
                    y: $audio.grainControl.positionJitter,
                    zLabel: "env",
                    z: $audio.grainControl.env1Position,
                    onDrag: {
                        if !isTouchingPosition {
                            audio.grainControl.env1Hold = true
                        }
                    }).opacity(audio.grainControl.env1Hold ? 1.0 : 0.1)
                XYControlView(
                    label: "size",
                    x: $audio.grainControl.size,
                    y: $audio.grainControl.sizeJitter,
                    zLabel: "env",
                    z: $audio.grainControl.env1Size
                )
            }
            
            // LFO
            HStack(spacing: Style.margin) {
                HStack {
                    Spacer()
                    LabelControlView(label: "lfo1", value: $audio.grainControl.lfo1Position)
                    LabelControlView(label: "lfo2", value: $audio.grainControl.lfo2Position)
                    Spacer()
                }
                HStack {
                    Spacer()
                    LabelControlView(label: "lfo1", value: $audio.grainControl.lfo1Size)
                    LabelControlView(label: "lfo2", value: $audio.grainControl.lfo2Size)
                    Spacer()
                }
            }
            
            // spread and pitch
            HStack(spacing: Style.margin) {
                XYControlView(
                    label: "spread",
                    x: $audio.grainControl.spread,
                    y: $audio.grainControl.spreadJitter,
                    zLabel: "env",
                    z: $audio.grainControl.env1Spread
                )
                XYControlView(
                    label: "pitch",
                    x: $audio.grainControl.pitch,
                    y: $audio.grainControl.pitchJitter,
                    zLabel: "env",
                    z: $audio.grainControl.env1Pitch
                )
            }
            
            // LFO
            HStack(spacing: Style.margin) {
                HStack {
                    Spacer()
                    LabelControlView(label: "lfo1", value: $audio.grainControl.lfo1Spread)
                    LabelControlView(label: "lfo2", value: $audio.grainControl.lfo2Spread)
                    Spacer()
                }
                HStack {
                    Spacer()
                    LabelControlView(label: "lfo1", value: $audio.grainControl.lfo1Pitch)
                    LabelControlView(label: "lfo2", value: $audio.grainControl.lfo2Pitch)
                    Spacer()
                }
            }
            
            HStack(spacing: Style.margin) {
                XYControlView(label: "density", x: $audio.grainControl.density)
                XYControlView(label: "ramp", x: $audio.grainControl.ramp)
            }
            .frame(height: shortHeight)
            
            HStack(spacing: Style.margin) {
                XYControlView(label: "lfo1", x: $audio.grainControl.lfo1Period)
                XYControlView(label: "lfo2", x: $audio.grainControl.lfo2Period)
            }
            .frame(height: shortHeight)
            
            HStack(spacing: Style.margin) {
                XYControlView(label: "attack", x: $audio.grainControl.env1AttackTime).disabled(audio.grainControl.env1Hold)
                XYControlView(label: "release", x: $audio.grainControl.env1ReleaseTime).disabled(audio.grainControl.env1Hold)
                XYControlView(label: "volume", x: $audio.grainControl.volume)
            }
            .frame(height: shortHeight)
            
        }.padding(.horizontal, Style.margin)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Audio())
    }
}
