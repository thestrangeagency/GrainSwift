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
        return Color(red: 1.0 - x, green: y, blue: 1.0, opacity: 0.2)
    }
    
    static var foreground: Color {
        get {
            return Self.colorFor(x: 0, y: 0)
        }
    }
    
    static var background: Color {
        get {
            return Self.colorFor(x: 1, y: 0)
        }
    }
}
