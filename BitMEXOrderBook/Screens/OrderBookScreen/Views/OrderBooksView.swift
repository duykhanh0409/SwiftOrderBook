//
//  OrderBookScreen.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct OrderBooksView: View {
    @ObservedObject var viewModel = WebSocketManager.shared.orderBookViewModel
   
    var body: some View {
        let rowsToShow = Array(viewModel.displayedRows.prefix(20))
        VStack(spacing: 0) {
            // Header Row
            OrderBookHeaderView()
            
            // List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(rowsToShow.enumerated()), id: \.offset) { index, row in
                        OrderBookRowView(
                            buyQty: row.buy.map { qtyString($0.size) },
                            buyPrice: row.buy.map { priceString($0.price) },
                            buyVolume: row.buy?.size ?? 0.0,
                            maxBuyVolume: viewModel.buyEntries.map { $0.size }.max() ?? 1,
                            sellPrice: row.sell.map { priceString($0.price) },
                            sellQty: row.sell.map { qtyString($0.size) },
                            sellVolume: row.sell?.size ?? 0.0,
                            maxSellVolume: viewModel.sellEntries.map { $0.size }.max() ?? 1
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
        }
        .background(Color.white)
    }
    
    func qtyString(_ qty: Double) -> String {
        let formatted = String(format: "%.4f", qty)
        return formatted
    }
    func priceString(_ price: Double) -> String {
        String(format: "%.1f", price)
    }
}

#Preview {
    OrderBooksView()
}
