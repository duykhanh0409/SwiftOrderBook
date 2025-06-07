//
//  Trade.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import Foundation

struct Trade: Identifiable, Equatable {
    let id: String
    let side: String
    let price: Double
    var size: Int
    let timestamp: Date
}
