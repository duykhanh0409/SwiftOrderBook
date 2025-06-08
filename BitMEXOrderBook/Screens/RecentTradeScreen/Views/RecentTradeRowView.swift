//
//  RecentTradeRowView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

import SwiftUI

struct RecentTradeRowView: View {
    let trade: Trade
    let isNew: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            HStack {
                Text(trade.price.formattedWithSeparator(decimalPlaces: 1))
                    .foregroundColor(trade.side == "Buy" ? .green : .red)
                    .frame(maxWidth: totalWidth * 0.33, alignment: .leading)
                Spacer()
                Text(trade.size.qtyString(trade.size))
                    .foregroundColor(trade.side == "Buy" ? .green : .red)
                    .frame(maxWidth: totalWidth * 0.33, alignment: .center)
                Spacer()
                Text(trade.timestamp.formattedTime)
                    .frame(maxWidth: totalWidth * 0.33, alignment: .trailing)
            }
            .font(.system(size: 16, design: .monospaced))
            .background(
                isNew ?
                (trade.side == "Buy" ? Color.green.opacity(0.15) : Color.red.opacity(0.15)) :
                    Color.clear
            )
            .animation(.easeOut(duration: 0.2), value: isNew)
        }
      
    }
    

}


//#Preview {
//    RecentTradeRowView()
//}
