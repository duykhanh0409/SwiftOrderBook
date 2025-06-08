//
//  OrderBookViewModel.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//


import Foundation
import Combine

class OrderBookViewModel: ObservableObject {
    static let shared = OrderBookViewModel()
    @Published var buyEntries: [OrderBookEntry] = []
    @Published var sellEntries: [OrderBookEntry] = []

    private var buyDict: [Int: OrderBookEntry] = [:]
    private var sellDict: [Int: OrderBookEntry] = [:]
    
    var displayedRows: [(buy: OrderBookEntry?, sell: OrderBookEntry?)] {
        let count = max(buyEntries.count, sellEntries.count, 20)
        // Take top 20 only
        return (0..<min(count, 20)).map { i in
            let buy = i < buyEntries.count ? buyEntries[i] : nil
            let sell = i < sellEntries.count ? sellEntries[i] : nil
            return (buy, sell)
        }
    }

    func processOrderBookL2Message(_ msg: [String: Any]) {
        guard let action = msg["action"] as? String,
              let dataArr = msg["data"] as? [[String: Any]] else { return }
        
        // I want run all mutation code on the main thread to prevent unexpected issue
        DispatchQueue.main.async {
            for entry in dataArr {
                guard let id = entry["id"] as? Int,
                      let side = entry["side"] as? String else { continue }
                let price = entry["price"] as? Double ?? 0
                let size = entry["size"] as? Double ?? 0
                
                switch action {
                case "insert":
                    let newEntry = OrderBookEntry(id: id, side: side, price: price, size: size)
                    if side == "Buy" { self.buyDict[id] = newEntry }
                    else { self.sellDict[id] = newEntry }
                case "update":
                    if side == "Buy", var exist = self.buyDict[id] {
                        exist.size = size
                        self.buyDict[id] = exist
                    }
                    if side == "Sell", var exist = self.sellDict[id] {
                        exist.size = size
                        self.sellDict[id] = exist
                    }
                case "delete":
                    if side == "Buy" { self.buyDict.removeValue(forKey: id) }
                    if side == "Sell" { self.sellDict.removeValue(forKey: id) }
                default:
                    break
                }
            }

            let topBuys = Array(self.buyDict.values).sorted { $0.price > $1.price }
            self.buyEntries = Array(topBuys.prefix(20))
            let topSells = Array(self.sellDict.values).sorted { $0.price < $1.price }
            self.sellEntries = Array(topSells.prefix(20))
        }
    }

   
    func reset() {
        buyDict.removeAll()
        sellDict.removeAll()
        buyEntries = []
        sellEntries = []
    }
}
