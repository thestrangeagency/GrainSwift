//
//  PositionControlView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/24/21.
//

import SwiftUI

struct PositionControlView: View {
    @EnvironmentObject var audio: Audio
    @Binding var touching: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let x = geometry.size.width * CGFloat(audio.grainControl.position)
                    
                    let sizeFraction = Double(Grain.length) / Double(Grain.bufferLength)
                    let sizeSpan = geometry.size.width * CGFloat(sizeFraction)
                    
                    let jitterFraction = audio.grainControl.maxJitter / Double(Grain.bufferLength)
                    let jitterSpan = geometry.size.width * CGFloat((audio.grainControl.positionJitter + audio.grainControl.sizeJitter) * jitterFraction) * 0.5
                    
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    
                    path.move(to: CGPoint(x: x + sizeSpan, y: 0))
                    path.addLine(to: CGPoint(x: x + sizeSpan, y: geometry.size.height))
                    
                    let jitterTop = geometry.size.height * 0.25
                    let jitterBottom = geometry.size.height * 0.75
                    
                    path.move(to: CGPoint(x: x - jitterSpan, y: jitterTop))
                    path.addLine(to: CGPoint(x: x - jitterSpan, y: jitterBottom))
                    
                    path.move(to: CGPoint(x: x + sizeSpan + jitterSpan, y: jitterTop))
                    path.addLine(to: CGPoint(x: x + sizeSpan + jitterSpan, y: jitterBottom))
                }
                .stroke(Style.foreground, lineWidth: 1)

                Rectangle()
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { value in
                                if audio.grainControl.env1Hold {
                                    audio.grainControl.env1Hold = false
                                }
                                if !touching {
                                    touching = true
                                    audio.grainControl.env1Reset()
                                }
                                audio.grainControl.position = Double(value.location.x / geometry.size.width)
                                audio.grainControl.positionJitter = 1.0 - Double(value.location.y / geometry.size.height)
                            }
                            .onEnded { _ in
                                touching = false
                                audio.grainControl.env1Release()
                            }
                    )
                    .foregroundColor(Color(white: 1.0, opacity: 0.0001)) // clear view ignores touches
            }
        }
    }
}

struct PositionControlView_Previews: PreviewProvider {
    static var previews: some View {
        PositionControlView(touching: .constant(false))
    }
}
