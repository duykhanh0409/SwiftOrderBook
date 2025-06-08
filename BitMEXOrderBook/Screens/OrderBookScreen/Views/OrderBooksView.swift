//
//  OrderBookScreen.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct OrderBooksView: View {
    @ObservedObject var viewModel = OrderBookViewModel.shared
   
    var body: some View {
     
        VStack(spacing: 0) {
            OrderBookHeaderView()
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    let buyCumulatives = viewModel.throttledBuyCumulativeVolumes
                    let sellCumulatives = viewModel.throttledSellCumulativeVolumes
                    let maxBuyCum = viewModel.throttledMaxBuyCumulativeVolume
                    let maxSellCum = viewModel.throttledMaxSellCumulativeVolume
                    
                    ForEach(Array(viewModel.throttledDisplayedRows.enumerated()), id: \.offset) { index, row in
                        OrderBookRowView(
                            buyQty: row.buy.map { $0.size.qtyString($0.size) },
                            buyPrice: row.buy.map { $0.price.formattedWithSeparator(decimalPlaces: 1) },
                            buyCumulativeVolume: index < buyCumulatives.count ? buyCumulatives[index] : nil,
                            maxBuyCumulativeVolume: maxBuyCum,
                            sellPrice: row.sell.map { $0.price.formattedWithSeparator(decimalPlaces: 1) },
                            sellQty: row.sell.map {$0.size.qtyString($0.size) },
                            sellCumulativeVolume: index < sellCumulatives.count ? sellCumulatives[index] : nil,
                            maxSellCumulativeVolume: maxSellCum
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(Color.white)
            }
        }
        .background(Color.white)
    }
    
    
}

#Preview {
    OrderBooksView()
}
