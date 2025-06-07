//
//  RecentTradesView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct RecentTradesView: View {
    @ObservedObject var viewModel = WebSocketManager.shared.recentTradesViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            RecentTradesHeaderView()
            Divider().padding(.bottom, 0)
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.trades) { trade in
                        RecentTradeRowView(
                            price: trade.price.formattedWithSeparator(decimalPlaces: 1),
                            qty: trade.size.qtyString,
                            time: trade.timestamp.formattedTime,
                            isBuy: trade.side == "Buy"
                        )
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .background(Color.white)
    }
}

#Preview {
    RecentTradesView()
}
