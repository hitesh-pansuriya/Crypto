//
//  DetailView.swift
//  Crypto
//
//  Created by PC on 29/09/22.
//

import SwiftUI


struct DetailLoadingView: View{

    @Binding var coin: CoinModel?

    var body: some View {
        ZStack{
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}




struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    init(coin: CoinModel){
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView{
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20){

                    overviewTitle
                    Divider()
                    overviewGrid

                    additionalView
                    Divider()
                    additionalViewGrid
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                navigationBarTrailingItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView{

    private var navigationBarTrailingItem: some View {
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }

    private var overviewTitle: some View {
        Text("OverView")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var additionalView: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var overviewGrid: some View{
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [])  {

            ForEach(vm.overviewStatistics){ stat in
                StatisticView(stat: stat)
            }
        }
    }

    private var additionalViewGrid: some View{
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [])  {

            ForEach(vm.additionalStatistics){ stat in
                StatisticView(stat: stat)
            }

        }
    }
}
