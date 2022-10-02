//
//  HomeView.swift
//  Crypto
//
//  Created by PC on 26/09/22.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var vm: HomeViewModel

    @State private var showPortfolio : Bool = false// animate right
    @State private var showPortfolioView : Bool = false// new sheet

    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView : Bool = false

    var body: some View {
        ZStack{
            //Background Layer
            Color.theme.background
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }

            //Content Layer
            VStack{
                homeHeader

                HomeStatsView(showPortfolio: $showPortfolio)

                SearchBarView(searchText: $vm.searchText)
                
                columnTitle

                if !showPortfolio{
                    allCoinsList
                        .transition(.move(edge: .leading))
                }

                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin   ), isActive: $showDetailView, label: { EmptyView()})
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {

    private var homeHeader : some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                    .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var allCoinsList : some View {
        List{
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }

        }
        .listStyle(PlainListStyle())
    }

    private var portfolioCoinsList : some View {
        List{
            ForEach(vm.portfolioCoin) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }

        }
        .listStyle(PlainListStyle())
    }

    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }

    private var columnTitle: some View {
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Prices")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)

            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)

    }
}
