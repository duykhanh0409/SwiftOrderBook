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
                Text(trade.side)
                Spacer()
                Text("\(trade.price, specifier: "%.2f")")
                Spacer()
                Text("\(trade.size)")
                Spacer()
                Text(trade.timestamp, style: .time)
            }
        }
    }
}

#Preview {
    RecentTradesView()
}
