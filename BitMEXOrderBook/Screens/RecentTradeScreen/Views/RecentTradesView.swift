//
//  RecentTradesView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct RecentTradesView: View {
    @ObservedObject var viewModel = RecentTradesViewModel.shared
    
    var body: some View {
        VStack {
            RecentTradesHeaderView()
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(viewModel.trades) { trade in
                        RecentTradeRowView(
                            trade: trade,
                            isNew: viewModel.recentlyInsertedIDs.contains(trade.id)
                        )
                        .padding(.vertical, 12)
                    }
                }
                .padding(.horizontal)
                .scrollIndicators(.hidden)
            }
        }
    }
}

//#Preview {
//    RecentTradesView()
//}
