//
//  LabelControlView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/31/21.
//

import SwiftUI

struct LabelControlView: View {
    var label = ""
    @Binding var value: Double
    
    var body: some View {
        if label != "" {
            let color = Style.colorFor(x: value, y: 0.0)
            let displayValue = String(format: "%02d", Int(value * 99))
            
            Text("\(label): \(displayValue)")
                .font(.system(size: 10, design: .monospaced))
                .padding(8)
                .foregroundColor(.black)
                .background(color)
                .cornerRadius(20)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { touch in
                            value = clamp(value - Double(touch.translation.height) / 4000.0, minValue: 0.0, maxValue: 1.0)
                        }
                        .onEnded { _ in
                        }
                )
        }
    }
}

struct LabelControlView_Previews: PreviewProvider {
    static var previews: some View {
        LabelControlView(label: "lfo", value: .constant(0.5))
    }
}
