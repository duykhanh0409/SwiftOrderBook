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
    let buyCumulativeVolume: Double?
    let maxBuyCumulativeVolume: Double
    let sellPrice: String?
    let sellQty: String?
    let sellCumulativeVolume: Double?
    let maxSellCumulativeVolume: Double
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                // Buy side
                ZStack(alignment: .trailing) {
                    GeometryReader { geo in
                        if let cum = buyCumulativeVolume, maxBuyCumulativeVolume > 0 {
                            let barWidth = geo.size.width * CGFloat(cum / maxBuyCumulativeVolume)
                            Rectangle()
                                .fill(Color.green.opacity(0.13))
                                .frame(width: barWidth, height: geo.size.height)
                                .position(x: geo.size.width - barWidth/2, y: geo.size.height / 2)
                        }
                    }
                    .allowsHitTesting(false)
                    HStack {
                        Text(buyQty ?? "")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text(buyPrice ?? "")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer().frame(width: 5)
                
                // Sell side
                ZStack(alignment: .leading) {
                    GeometryReader { geo in
                        if let cum = sellCumulativeVolume, maxSellCumulativeVolume > 0 {
                            let barWidth = geo.size.width  * CGFloat(cum / maxSellCumulativeVolume)
                            Rectangle()
                                .fill(Color.red.opacity(0.13))
                                .frame(
                                    width: barWidth,
                                    alignment: .leading
                                )
                        }
                    }
                    .allowsHitTesting(false)
                    
                    HStack {
                        Text(sellPrice ?? "")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text(sellQty ?? "")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .font(.system(size: 16, design: .monospaced))
            .frame(height: 28)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}


//#Preview {
//    OrderBookRowView(buyQty: "0.1709", buyPrice: "51816.3", sellPrice: "51816.4", sellQty: "3.3893")
//}
