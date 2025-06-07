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
        VStack(spacing: 0) {
            // Header Row
            HStack(spacing: 0) {
                Text("Qty")
                    .frame(width: 60, alignment: .trailing)
                Text("Price (USD)")
                    .frame(width: 80, alignment: .trailing)
                Spacer()
                    .frame(width: 20)
                Text("Price (USD)")
                    .frame(width: 80, alignment: .leading)
                Text("Qty")
                    .frame(width: 60, alignment: .leading)
            }
            .font(.system(size: 13, weight: .bold, design: .monospaced))
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            
            
            // List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(0..<20, id: \.self) { i in
                        let buy = i < viewModel.buyEntries.count ? viewModel.buyEntries[i] : nil
                        let sell = i < viewModel.sellEntries.count ? viewModel.sellEntries[i] : nil
                        OrderBookRowView(
                            buyQty: buy.map { qtyString($0.size) },
                            buyPrice: buy.map { priceString($0.price) },
                            buyVolume: buy.map { $0.size },
                            maxBuyVolume: viewModel.buyEntries.map { $0.size }.max() ?? 1,
                            sellPrice: sell.map { priceString($0.price) },
                            sellQty: sell.map { qtyString($0.size) },
                            sellVolume: sell.map { $0.size },
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
    
    func qtyString(_ qty: Int) -> String {
        String(format: "%.4f", Double(qty))
    }
    func priceString(_ price: Double) -> String {
        String(format: "%.1f", price)
    }
}

#Preview {
    OrderBooksView()
}
