//
//  ContentView.swift
//  Crypto
//
//  Created by PC on 26/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()

            VStack(spacing: 40){
                Text("Accent color")
                    .foregroundColor(Color.theme.accent)
                Text("secondary Text color")
                    .foregroundColor(Color.theme.secondaryText)
                Text("Red color")
                    .foregroundColor(Color.theme.red)
                Text("Green color")
                    .foregroundColor(Color.theme.green)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
