//
//  OrderBookHeaderView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct OrderBookHeaderView: View {
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text("Qty")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Price (USD)")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Qty")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.secondary)
            }
            .font(.system(size: 13, weight: .bold, design: .monospaced))
            .padding(.horizontal)
            .frame(height: 22)
            .background(Color(.systemGray6))
            
        }
        .frame(height: 22) // Set fixed height for header
    }
}

#Preview {
    OrderBookHeaderView()
}
