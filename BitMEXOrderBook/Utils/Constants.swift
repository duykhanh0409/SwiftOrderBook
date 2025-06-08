//
//  Constants.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 8/6/25.
//

enum BitMEXConstants {
    static let webSocketURL = "wss://www.bitmex.com/realtime"
    static let orderBookChannel = "orderBookL2:XBTUSD"
    static let tradeChannel = "trade:XBTUSD"
}

enum Tab {
    case orderBook, recentTrades
}
