//
//  GrainView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/8/21.
//

import SwiftUI

struct GrainView: View {
    let position: Double
    let size: Double
    let ramp: Double
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    if let buffer = Grain.buffer {
                        let start = UInt32(Double(Grain.bufferLength) * position)
                        let end = start + Grain.length
                        WaveView(buffer: buffer, start: start, end: end)
                    }
                    Path { path in
                        let halfWidth = CGFloat(geometry.size.width * 0.5)
                        let floatRamp = CGFloat(ramp)
                        path.move(to: CGPoint(x: 0, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: halfWidth * floatRamp, y:0))
                        path.addLine(to: CGPoint(x: geometry.size.width - halfWidth * floatRamp, y:0))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    }.stroke(Color.red, lineWidth: 1)
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct GrainView_Previews: PreviewProvider {
    static var previews: some View {
        GrainView(position: 0.0, size: 0.0, ramp: 0.5)
    }
}
