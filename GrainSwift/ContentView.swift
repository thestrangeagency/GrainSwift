//
//  ContentView.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/1/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audio: Audio
    @State var density = 0.0
    
    var body: some View {
        VStack {
            Text("Audio is \(audio.source?.loaded ?? false ? "loaded" : "not loaded")")
                .padding()
                .environmentObject(audio)
            
            Text("Density now at: \(density)")
                .padding()
            
            Button(action: {
                density = audio.increaseDensity()
            }, label: {
                Text("Denser Please")
            })
            .padding()
            
        }.onAppear(perform: {
            density = audio.getDensity()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Audio())
    }
}
