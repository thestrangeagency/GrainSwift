//
//  GrainSwiftApp.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/1/21.
//

import SwiftUI

@main
struct GrainSwiftApp: App {
    @StateObject var audio = Audio()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audio)
        }
    }
}
