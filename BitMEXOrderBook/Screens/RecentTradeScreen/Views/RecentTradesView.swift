//
//  RecentTradesView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct RecentTradesView: View {
    @ObservedObject var wsManager = WebSocketManager.shared
    
    var body: some View {
        List(wsManager.tradesData) { trade in
            HStack {
                Text("\(trade.price, specifier: "%.2f")")
                    .foregroundColor(trade.side == "Buy" ? .green : .red)
                Spacer()
                Text("\(trade.size)")
                    .foregroundColor(trade.side == "Buy" ? .green : .red)
                Spacer()
                Text(trade.timestamp, style: .time)
                    .font(.caption)
            }
            .padding(.vertical, 2)
        }
    }
}

#Preview {
    RecentTradesView()
}
