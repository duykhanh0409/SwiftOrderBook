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
                            buyPrice: row.buy.map { $0.price.formattedWithSeparator(decimalPlaces: 1) },
                            buyVolume: row.buy?.size ?? 0.0,
                            maxBuyVolume: viewModel.buyEntries.map { $0.size }.max() ?? 1,
                            sellPrice: row.sell.map { $0.price.formattedWithSeparator(decimalPlaces: 1) },
                            sellQty: row.sell.map { qtyString($0.size) },
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
    
    func qtyString(_ qty: Double) -> String {
        let normalizedQty = qty / 100000.0
        return String(format: "%.4f", normalizedQty)
    }
    
    func priceString(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = "."
        formatter.groupingSize = 3
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}

#Preview {
    OrderBooksView()
}
