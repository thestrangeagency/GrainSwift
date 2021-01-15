//
//  WaveView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/7/21.
//

import SwiftUI
import AVFoundation

struct WaveView: View {
    var buffer: AVAudioPCMBuffer
    var start: UInt32
    var end: UInt32
    var position: Double
    
    init(buffer: AVAudioPCMBuffer, start: UInt32, end: UInt32, position: Double = -1.0) {
        self.start = start
        self.end = end
        self.buffer = buffer
        self.position = position
    }
    
    init(buffer: AVAudioPCMBuffer, position: Double) {
        self.init(buffer: buffer, start: 0, end: buffer.frameLength, position: position)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    Path { path in
                        
                        let width = geometry.size.width
                        let halfHeight = Int(geometry.size.height / 2.0)
                        let stride = CGFloat(end - start) / width
                        
                        for x in 0..<Int(width) {
                            path.move(to: CGPoint(x: x, y: halfHeight))
                            
                            let channels = buffer.stride
                            var sample:Float = 0.0
                            for i in 0..<channels {
                                sample += buffer.floatChannelData?[i][(Int(start) + x * Int(stride)) % Int(buffer.frameLength)] ?? 0.0
                            }
                            let y = halfHeight + Int(sample * Float(halfHeight) / Float(channels))
                            
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
        return WaveView(buffer: AVAudioPCMBuffer(), position: 0.5)
    }
}
