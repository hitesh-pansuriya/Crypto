//
//  DetailViewModel.swift
//  Crypto
//
//  Created by PC on 29/09/22.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {

    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []

    @Published var coin: CoinModel
    private let coinDetailService:  CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscriber() 
    }

    private func addSubscriber(){
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink {[weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
    }


    private func mapDataToStatistics(CoinDetailModel: CoinDetailModel?, coinModel: CoinModel ) -> (overview: [StatisticModel], additional: [StatisticModel]) {

        let overviewArray = creatOverviewArray(coinModel: coinModel)
        let additionalArray = creatAdditionalArray(CoinDetailModel: CoinDetailModel, coinModel: coinModel)

        return (overviewArray, additionalArray)
    }

   private func creatOverviewArray(coinModel: CoinModel) -> [StatisticModel]{

        //overview
        let price = coinModel.currentPrice.asCurrancyWith2Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)

        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalaization", value: marketCap, percentageChange: marketCapPercentChange)

        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)

        let overviewArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]

        return overviewArray
    }

    private func creatAdditionalArray(CoinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel]{
        //additional
        let high = coinModel.high24H?.asCurrancyWith6Decimals() ?? "n/a"
        let highstat = StatisticModel(title: "24 high", value: high)

        let low = coinModel.low24H?.asCurrancyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24 Low", value: low)

        let priceChange = coinModel.priceChange24H?.asCurrancyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)

        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)

        let blocTime = CoinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blocTime == 0 ? "n/a" : "\(blocTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = CoinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)

        let additionalArray: [StatisticModel] = [
            highstat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]

        return additionalArray
    }
}
