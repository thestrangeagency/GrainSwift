//
//  Style.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/30/21.
//

import Foundation
import SwiftUI

struct Style {
    static func colorFor(x: Double, y: Double) -> Color {
        return Color(red: 1.0 - y, green: 1.0 - x, blue: 1.0, opacity: 0.5)
    }
    
    static var foreground: Color {
        get {
            return Color(.black)
        }
    }
    
    static var background: Color {
        get {
            return Self.colorFor(x: 1, y: 1)
        }
    }
    
    static var disabled: Color = Color(white: 0.25, opacity: 0.25)
}
