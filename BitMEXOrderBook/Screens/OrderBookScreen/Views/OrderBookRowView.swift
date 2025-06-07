//
//  OrderBookRowView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct OrderBookRowView: View {
    let buyQty: String?
    let buyPrice: String?
    let buyVolume: Int?
    let maxBuyVolume: Int
    let sellPrice: String?
    let sellQty: String?
    let sellVolume: Int?
    let maxSellVolume: Int
    
    var body: some View {
        ZStack {
            // Buy bar background
            if let buyVolume = buyVolume, maxBuyVolume > 0 {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.green.opacity(0.12))
                        .frame(width: CGFloat(buyVolume) / CGFloat(maxBuyVolume) * 140, height: 28)
                    Spacer()
                }
            }
            // Sell bar background
            if let sellVolume = sellVolume, maxSellVolume > 0 {
                HStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(Color.red.opacity(0.12))
                        .frame(width: CGFloat(sellVolume) / CGFloat(maxSellVolume) * 140, height: 28)
                }
            }
            // Row content
            HStack(spacing: 0) {
                Text(buyQty ?? "")
                    .foregroundColor(.green)
                    .frame(width: 60, alignment: .trailing)
                Text(buyPrice ?? "")
                    .foregroundColor(.green)
                    .frame(width: 80, alignment: .trailing)
                Spacer().frame(width: 20)
                Text(sellPrice ?? "")
                    .foregroundColor(.red)
                    .frame(width: 80, alignment: .leading)
                Text(sellQty ?? "")
                    .foregroundColor(.red)
                    .frame(width: 60, alignment: .leading)
            }
            .font(.system(size: 14, design: .monospaced))
            .frame(height: 28)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

//#Preview {
//    OrderBookRowView(buyQty: "0.1709", buyPrice: "51816.3", sellPrice: "51816.4", sellQty: "3.3893")
//}
