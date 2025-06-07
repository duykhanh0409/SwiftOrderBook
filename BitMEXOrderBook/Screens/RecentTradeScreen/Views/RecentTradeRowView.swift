//
//  RecentTradeRowView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

import SwiftUI

struct RecentTradeRowView: View {
    let price: String
    let qty: String
    let time: String
    let isBuy: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(price)
                .foregroundColor(isBuy ? .green : .red)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(qty)
                .foregroundColor(isBuy ? .green : .red)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(time)
                .foregroundColor(isBuy ? .green : .red)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.system(size: 15, weight: .medium, design: .monospaced))
        .padding(.vertical, 4)
    }
}


//#Preview {
//    RecentTradeRowView()
//}
