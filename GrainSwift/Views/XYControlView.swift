//
//  XYControlView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/29/21.
//

import SwiftUI

struct XYControlView: View {
    var label = ""
    var zLabel = ""
    @Binding var x: Double
    @Binding var y: Double
    @Binding var z: Double
    var hasY: Bool = true
    var onDrag: (() -> Void)?
    @Environment(\.isEnabled) private var isEnabled
    
    init(label: String, x: Binding<Double>, onDrag: (() -> Void)? = nil) {
        self.label = label
        _x = x
        _y = .constant(0.5)
        _z = .constant(0.5)
        hasY = false
        self.onDrag = onDrag
    }
    
    init(label: String, x: Binding<Double>, y: Binding<Double>, onDrag: (() -> Void)? = nil) {
        self.label = label
        _x = x
        _y = y
        _z = .constant(0.5)
        self.onDrag = onDrag
    }
    
    init(label: String, x: Binding<Double>, y: Binding<Double>, zLabel: String, z: Binding<Double>, onDrag: (() -> Void)? = nil) {
        self.label = label
        self.zLabel = zLabel
        _x = x
        _y = y
        _z = z
        self.onDrag = onDrag
    }
    
    var body: some View {
        
        VStack {
            let color = isEnabled ? Style.colorFor(x: x, y: y) : Style.disabled
            
            GeometryReader { geometry in
                ZStack {
                    // background
                    Rectangle()
                        .foregroundColor(color)
                    
                    // calculate cursor position
                    let cursorSize: CGFloat = min(geometry.size.width, geometry.size.height) * 0.1
                    let width = geometry.size.width - cursorSize
                    let height = geometry.size.height - cursorSize
                    let xPos = cursorSize * 0.5 + CGFloat(x) * width
                    let yPos = geometry.size.height - (cursorSize * 0.5 + CGFloat(y) * height)
                    
                    // cursor
                    Rectangle()
                        .frame(width: cursorSize, height: cursorSize, alignment: .center)
                        .position(x: xPos, y: yPos)
                    
                    // jitter
                    if hasY {
                        let yFactor: CGFloat = 24.0 * CGFloat(y)
                        Rectangle()
                            .frame(width: cursorSize + yFactor, height: 1, alignment: .center)
                            .position(x: xPos, y: yPos)
                            .clipped()
                    }
                    
                    // touch control
                    Rectangle()
                        .inset(by: cursorSize / 2.0)
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged { value in
                                    x = clamp(Double(value.location.x / geometry.size.width), minValue: 0, maxValue: 1.0)
                                    y = clamp(1.0 - Double(value.location.y / geometry.size.height), minValue: 0, maxValue: 1.0)
                                    onDrag?()
                                }
                                .onEnded { _ in
                                }
                        )
                        .foregroundColor(Color(white: 1.0, opacity: 0.0001)) // clear view ignores touches
                }
            }
            
            HStack {
                Text(label)
                    .font(.system(size: 10, design: .monospaced))
                    .padding(8)
                    .foregroundColor(.black)
                    .background(color)
                    .cornerRadius(20)
             
                if zLabel != "" {
                    LabelControlView(label: zLabel, value: $z)
                }
            }
            
        }.opacity(isEnabled ? 1.0 : 0.1)
    }
}

struct XYControlView_Previews: PreviewProvider {
    @State static var x = 0.5
    @State static var y = 0.5
    static var previews: some View {
        XYControlView(label: "density", x: $x, y: $y)
            .frame(width: 180.0, height: 80.0)
    }
}
