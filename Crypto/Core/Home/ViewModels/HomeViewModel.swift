//
//  HomeViewModel.swift
//  Crypto
//
//  Created by PC on 26/09/22.
//

import Foundation

class HomeViewModel : ObservableObject{
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoin: [CoinModel] = []

    init(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.allCoins.append(DeveloperPreview.instance.coin)
        }
    }
}

