//
//  HomeViewModel.swift
//  Crypto
//
//  Created by PC on 26/09/22.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{

    @Published var statistics: [StatisticModel] = []

    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoin: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""  

    private let coinDataServices = CoinDataService()
    private let markDataServices = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cacellables = Set<AnyCancellable>()

    init(){
       addSubscribers()
    }

    func addSubscribers(){

        //updates allcoins
        $searchText
            .combineLatest(coinDataServices.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cacellables)

        //update potfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoin = returnedCoins
            }
            .store(in: &cacellables)


        //update market data
        markDataServices.$marketData
            .combineLatest($portfolioCoin)
            .map(mapGlobalMarketData) 
            .sink {[weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cacellables)

    }

    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData(){
        isLoading = true
        coinDataServices.getCoin()
        markDataServices.getData()
        HapticManager.notification(type: .success)
    }

    private func filterCoins(text: String, coin: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coin
        }

        let lowercasedText = text.lowercased()

        return  coin.filter { (Coin) -> Bool in
            return Coin.name.lowercased().contains(lowercasedText) ||
            Coin.symbol.lowercased().contains(lowercasedText) ||
            Coin.id.lowercased().contains(lowercasedText)
        }
    }

    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portflioEntity: [PortfolioEntity]) -> [CoinModel]{
        allCoins.compactMap { (coin) -> CoinModel? in
            guard let entity = portflioEntity.first(where: { $0.coinID == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel]{
        var stats: [StatisticModel] = []

        guard let data = marketDataModel else  {
            return stats
        }

        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Diminance", value: data.volume)

        let portfolioValue = portfolioCoins
                                .map({$0.currentHoldingsValue})
                                .reduce(0, +)

        let previousValue =
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousVlue = currentValue / (1 + percentChange)
                return previousVlue
            }
            .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / portfolioValue) * 100

        let portfolio = StatisticModel(
            title: "Portfolio Valu",
            value: portfolioValue.asCurrancyWith2Decimals(),
            percentageChange: percentageChange )


        stats.append(contentsOf:[
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}

