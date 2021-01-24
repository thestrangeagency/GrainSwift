//
//  PositionControlView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/24/21.
//

import SwiftUI

struct PositionControlView: View {
    @EnvironmentObject var audio: Audio
    @Binding var touching:Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let x = geometry.size.width * CGFloat(audio.grainControl.position)
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y:geometry.size.height))
                }.stroke(Color.red, lineWidth: 1)

                Rectangle()
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { value in
                                if audio.grainControl.ampHold {
                                    audio.grainControl.ampHold = false
                                }
                                if !touching {
                                    touching = true
                                    audio.grainControl.ampReset()
                                }
                                audio.grainControl.position = Double(value.location.x / geometry.size.width)
                            }
                            .onEnded { _ in
                                touching = false
                                audio.grainControl.ampRelease()
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
