//
//  CryptoApp.swift
//  Crypto
//
//  Created by PC on 26/09/22.
//

import SwiftUI

@main
struct CryptoApp: App {
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
