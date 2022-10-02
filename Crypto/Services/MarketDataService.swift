//
//  MarketDataService.swift
//  Crypto
//
//  Created by PC on 28/09/22.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData : MarketDataModel? = nil

    var marketDataSubscription: AnyCancellable?

    init(){
        getData()
    }

    func getData(){
        guard let url = URL(string:  "https://api.coingecko.com/api/v3/global") else {
            print("eroooooooooooooo")
            return

        }

        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}

