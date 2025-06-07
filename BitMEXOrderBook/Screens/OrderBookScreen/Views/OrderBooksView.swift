//
//  OrderBookScreen.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

struct OrderBookScreen: View {
    @ObservedObject var wsManager = WebSocketManager.shared
    
    var body: some View {
        List(wsManager.orderBookData) { entry in
            HStack {
                Text(entry.side)
                Spacer()
                Text("\(entry.price, specifier: "%.2f")")
                Spacer()
                Text("\(entry.size)")
            }
        }
    }
}

#Preview {
    OrderBookScreen()
}
