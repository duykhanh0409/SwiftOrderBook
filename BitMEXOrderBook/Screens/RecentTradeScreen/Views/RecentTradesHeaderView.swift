//
//  RecentTradeHeader.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI


struct RecentTradesHeaderView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Price (USD)")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Qty")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Time")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(.secondary)
        .padding(.vertical, 5)
        .background(Color(.systemGray6))
    }
}

#Preview {
    RecentTradesHeaderView()
}
