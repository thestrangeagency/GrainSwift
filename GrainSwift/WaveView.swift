//
//  WaveView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/7/21.
//

import SwiftUI
import AVFoundation

struct WaveView: View {
    let buffer: AVAudioPCMBuffer
    
    var body: some View {
        ZStack {
            Color.init(hue: 0, saturation: 0, brightness: 0.95)
            GeometryReader { geometry in
                Path { path in
                    
                    let width = Int(geometry.size.width)
                    let halfHeight = Int(geometry.size.height / 2.0)
                    let stride = buffer.frameLength / UInt32(width)
                    
                    for x in 0..<width {
                        path.move(
                            to: CGPoint(
                                x: x,
                                y: halfHeight
                            )
                        )
                        
                        // TODO mono for now
                        let sample = buffer.floatChannelData?[0][x * Int(stride)] ?? 0.0
                        let y = halfHeight + Int(sample * Float(halfHeight))
                        
                        path.addLine(
                            to: CGPoint(
                                x: x,
                                y: y
                            )
                        )
                    }
                }.stroke(Color.blue, lineWidth: 1)
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        return WaveView(buffer: AVAudioPCMBuffer())
    }
}
