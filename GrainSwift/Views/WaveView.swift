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
    let start: UInt32
    let end: UInt32
    let position: Double
    
    var body: some View {
        ZStack {
            Color.init(hue: 0, saturation: 0, brightness: 0.95)
            GeometryReader { geometry in
                ZStack {
                    Path { path in
                        
                        let width = geometry.size.width
                        let halfHeight = Int(geometry.size.height / 2.0)
                        let stride = CGFloat(end - start) / width
                        
                        for x in 0..<Int(width) {
                            path.move(to: CGPoint(x: x, y: halfHeight))
                            
                            // TODO mono for now
                            let sample = buffer.floatChannelData?[0][Int(start) + x * Int(stride)] ?? 0.0
                            let y = halfHeight + Int(sample * Float(halfHeight))
                            
                            path.addLine(to: CGPoint(x: x, y: y)
                            )
                        }
                    }.stroke(Color.blue, lineWidth: 1)
                    
                    Path { path in
                        let x = geometry.size.width * CGFloat(position)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y:geometry.size.height))
                    }.stroke(Color.red, lineWidth: 1)
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        return WaveView(buffer: AVAudioPCMBuffer(), start: 0, end: 0, position: 0.5)
    }
}
