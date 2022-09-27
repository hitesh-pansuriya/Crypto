//
//  CircleImageView.swift
//  Crypto
//
//  Created by PC on 27/09/22.
//

import SwiftUI


struct CoinImageView: View {
    @StateObject var vm: coinImageViewModel

    init(coin: CoinModel){
        _vm = StateObject(wrappedValue: coinImageViewModel(coin: coin))
    }

    var body: some View {
        ZStack{
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else if vm.isLoading {
                ProgressView()
            }else{
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
