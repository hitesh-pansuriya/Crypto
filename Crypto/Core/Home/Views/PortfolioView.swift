//
//  PortfolioView.swift
//  Crypto
//
//  Created by PC on 28/09/22.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm : HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .navigationBarItems(leading: XMarkButton(){
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarItems(trailing: trailingNavigationButton)
            .onChange(of: vm.searchText) { newValue in
                if newValue == ""{
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {

    private var coinLogoList:some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [.init(.adaptive(minimum: 100))], spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoin : vm.allCoins){ coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }

    private func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin

        if let portfolioCoin = vm.portfolioCoin.first(where: {$0.id == coin.id}),
            let amount = portfolioCoin.currentHoldings   {
                quantityText = "\(amount)"

        }else {
            quantityText = ""
        }
    }

    private func getCurrentValue() -> Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }

    private var portfolioInputSection: some View{
        VStack(spacing: 20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrancyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount in your portfolio:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value")
                Spacer()
                Text(getCurrentValue().asCurrancyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }

    private var trailingNavigationButton: some View {
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1 : 0
            )

        }
        .font(.headline)
    }

    private func saveButtonPressed(){
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
            else {return}

        //save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)

        //show the checkmark
        withAnimation(.easeIn){
            showCheckMark = true
            removeSelectedCoin()
        }

        //hide keyboard
        UIApplication.shared.endEditing()

        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }

    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}
