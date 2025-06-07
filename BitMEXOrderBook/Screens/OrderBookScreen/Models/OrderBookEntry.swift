//
//  OrderBookEntry.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import Foundation

struct OrderBookEntry: Identifiable, Equatable {
    let id: Int
    let side: String
    let price: Double
    var size: Double
}
