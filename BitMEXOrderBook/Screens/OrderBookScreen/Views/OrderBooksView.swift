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
        let rowsToShow = Array(viewModel.displayedRows.prefix(20))
        VStack(spacing: 0) {
            OrderBookHeaderView()
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(rowsToShow.enumerated()), id: \.offset) { index, row in
                        OrderBookRowView(
                            buyQty: row.buy.map { $0.size.qtyString($0.size) },
                            buyPrice: row.buy.map { $0.price.formattedWithSeparator(decimalPlaces: 1) },
                            buyVolume: row.buy?.size ?? 0.0,
                            maxBuyVolume: viewModel.buyEntries.map { $0.size }.max() ?? 1,
                            sellPrice: row.sell.map { $0.price.formattedWithSeparator(decimalPlaces: 1) },
                            sellQty: row.sell.map {$0.size.qtyString($0.size) },
                            sellVolume: row.sell?.size ?? 0.0,
                            maxSellVolume: viewModel.sellEntries.map { $0.size }.max() ?? 1
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
