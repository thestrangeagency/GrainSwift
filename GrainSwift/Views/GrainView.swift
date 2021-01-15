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
    let positionJitter: Double
    let sizeJitter: Double
    let ramp: Double
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    // draw wave view
                    if let buffer = Grain.buffer {
                        let start = UInt32(Double(Grain.bufferLength) * position)
                        let end = start + Grain.length
                        let startMax = start + Grain.indexJitter
                        let endMax = startMax + Grain.length + Grain.lengthJitter
                        ZStack {
                            WaveView(buffer: buffer, start: start, end: end).opacity(0.5)
                            WaveView(buffer: buffer, start: startMax, end: endMax).opacity(0.5)
                        }
                    }
                    // draw ramp
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
        GrainView(position: 0.0, size: 0.0, positionJitter: 0.0, sizeJitter: 0.0, ramp: 0.5)
    }
}
