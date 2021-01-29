//
//  XYControlView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/29/21.
//

import SwiftUI

struct XYControlView: View {
    @State var x = 0.5
    @State var y = 0.5
    @State var label = "Density"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                // background
                Rectangle()
                    .foregroundColor(.yellow)
                
                // calculate cursor position
                let cursorSize: CGFloat = min(geometry.size.width, geometry.size.height) * 0.1
                let width = geometry.size.width - cursorSize
                let height = geometry.size.height - cursorSize
                let xPos = cursorSize * 0.5 + CGFloat(x) * width
                let yPos = cursorSize * 0.5 + CGFloat(y) * height
                
                // cursor
                Rectangle()
                    .frame(width: cursorSize, height: cursorSize, alignment: .center)
                    .position(x: xPos, y: yPos)
                
                // blur width horizontally
                ForEach(0..<10) { i in
                    let yFactor: CGFloat = 4.0 * CGFloat(i) * (1.0 - CGFloat(y))
                    Rectangle()
                        .frame(width: cursorSize + yFactor, height: cursorSize, alignment: .center)
                        .position(x: xPos, y: yPos)
                        .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.1))
                }.clipped()

                Text(label)
                    .foregroundColor(.black)
                
                // touch control
                Rectangle()
                    .inset(by: cursorSize / 2.0)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { value in
                                x = Double(value.location.x / geometry.size.width)
                                y = Double(value.location.y / geometry.size.height)
                                x = clamp(x, minValue: 0, maxValue: 1.0)
                                y = clamp(y, minValue: 0, maxValue: 1.0)
                            }
                            .onEnded { _ in
                            }
                    )
                    .foregroundColor(Color(white: 1.0, opacity: 0.0001)) // clear view ignores touches
            }
        }
    }
}

struct XYControlView_Previews: PreviewProvider {
    static var previews: some View {
        XYControlView()
            .frame(width: 120.0, height: 80.0)
    }
}
