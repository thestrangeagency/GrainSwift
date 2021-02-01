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
    let spread: Double
    
    var body: some View {
        GeometryReader { outerGeometry in
            HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: outerGeometry.size.width * CGFloat(spread) * 0.25, height: outerGeometry.size.height)

                GeometryReader { geometry in
                    ZStack {
                        // wave view
                        if let buffer = Grain.buffer {
                            let start = UInt32(Double(Grain.bufferLength) * position)
                            let end = start + Grain.length
                            let startMax = start + Grain.indexJitter
                            let endMax = startMax + Grain.length + Grain.lengthJitter
                            ZStack {
                                let steps = 10
                                ForEach(0..<steps) { step in
                                    let perStep = 1.0 / Double(steps)
                                    
                                    // linterp unwrapped else compiler confused about types
                                    let progress = Double(step) * perStep
                                    let startProgress = Double(startMax - start) * progress
                                    let endProgress = Double(endMax - end) * progress
                                    let stepStart = start + UInt32(startProgress)
                                    let stepEnd = end + UInt32(endProgress)
                                    
                                    WaveView(buffer: buffer, start: stepStart, end: stepEnd).opacity(perStep)
                                }
                            }
                        }

                        let halfWidth = CGFloat(geometry.size.width * 0.5)
                        let halfHeight = CGFloat(geometry.size.height * 0.5)
                        let floatRamp = CGFloat(ramp)
                        
                        // top ramp, x starts at -1 to deglitch edge rendering
                        Path { path in
                            path.move(to: CGPoint(x: -1, y: 0))
                            path.addLine(to: CGPoint(x: -1, y: halfHeight))
                            path.addLine(to: CGPoint(x: halfWidth * floatRamp, y: 0))
                            path.addLine(to: CGPoint(x: geometry.size.width - halfWidth * floatRamp, y: 0))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: halfHeight))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                            path.addLine(to: CGPoint(x: -1, y: 0))
                        }.fill(Color.white)
                        
                        // bottom ramp
                        Path { path in
                            path.move(to: CGPoint(x: -1, y: geometry.size.height))
                            path.addLine(to: CGPoint(x: -1, y: halfHeight))
                            path.addLine(to: CGPoint(x: halfWidth * floatRamp, y: geometry.size.height))
                            path.addLine(to: CGPoint(x: geometry.size.width - halfWidth * floatRamp, y: geometry.size.height))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: halfHeight))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                            path.addLine(to: CGPoint(x: -1, y: geometry.size.height))
                        }.fill(Color.white)
                    }
                }
                
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: outerGeometry.size.width * CGFloat(spread) * 0.25, height: outerGeometry.size.height)
            }
        }
    }
}

struct GrainView_Previews: PreviewProvider {
    static var previews: some View {
        GrainView(position: 0.0, size: 0.0, positionJitter: 0.0, sizeJitter: 0.0, ramp: 0.5, spread: 0.0)
    }
}
