//
//  OrderBookHeaderView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct OrderBookHeaderView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Qty").frame(width: 60, alignment: .trailing).foregroundColor(.secondary)
            Text("Price (USD)").frame(width: 80, alignment: .trailing).foregroundColor(.secondary)
            Rectangle().frame(width: 1).foregroundColor(Color.gray.opacity(0.15))
            Text("Price (USD)").frame(width: 80, alignment: .leading).foregroundColor(.secondary)
            Text("Qty").frame(width: 60, alignment: .leading).foregroundColor(.secondary)
        }
        .font(.system(size: 13, weight: .bold, design: .monospaced))
        .frame(width: .infinity, height: 22)
        .background(Color(.systemGray6))
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    OrderBookHeaderView()
}
