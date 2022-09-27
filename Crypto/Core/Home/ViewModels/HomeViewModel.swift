//
//  HomeViewModel.swift
//  Crypto
//
//  Created by PC on 26/09/22.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoin: [CoinModel] = []

    private var dataServices = CoinDataService()
    private var cacellables = Set<AnyCancellable>()

    init(){
       addSubscribers()
    }

    func addSubscribers(){
        dataServices.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cacellables)
    }
}

