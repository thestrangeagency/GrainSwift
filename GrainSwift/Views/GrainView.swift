//
//  GrainView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/8/21.
//

import SwiftUI

struct GrainView: View {
    let position: Double
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    if let buffer = Grain.buffer {
                        let start = UInt32(Double(Grain.bufferLength) * position)
                        let end = start + Grain.length
                        WaveView(buffer: buffer, start: start, end:end, position: -1.0)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct GrainView_Previews: PreviewProvider {
    static var previews: some View {
        GrainView(position: 0.0)
    }
}
