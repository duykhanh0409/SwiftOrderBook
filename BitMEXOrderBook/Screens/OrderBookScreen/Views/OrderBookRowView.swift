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
    let buyVolume: Double?
    let maxBuyVolume: Double
    let sellPrice: String?
    let sellQty: String?
    let sellVolume: Double?
    let maxSellVolume: Double
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                HStack{
                    Text(buyQty ?? "")
                        .foregroundColor(.black)
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    Text(buyPrice ?? "")
                        .foregroundColor(.green)
                        .frame(width: .infinity, alignment: .trailing)
                }
                Spacer().frame(width: 5)
                HStack {
                    Text(sellPrice ?? "")
                        .foregroundColor(.red)
                        .frame(width: .infinity, alignment: .leading)
                    Spacer()
                    Text(sellQty ?? "")
                        .foregroundColor(.black)
                        .frame(width: .infinity, alignment: .trailing)
                }
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
