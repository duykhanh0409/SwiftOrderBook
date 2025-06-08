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
    
    @Published var throttledBuyEntries: [OrderBookEntry] = []
    @Published var throttledSellEntries: [OrderBookEntry] = []

    private var buyDict: [Int: OrderBookEntry] = [:]
    private var sellDict: [Int: OrderBookEntry] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    // The orderBook socket sends data very frequently.
    // Apply throttle here to prevent the UI from updating too rapidly.
    init() {
        $buyEntries
            .throttle(for: .milliseconds(120), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] value in
                self?.throttledBuyEntries = value
            }
            .store(in: &cancellables)
        
        $sellEntries
            .throttle(for: .milliseconds(120), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] value in
                self?.throttledSellEntries = value
            }
            .store(in: &cancellables)
    }
    
    var throttledDisplayedRows: [(buy: OrderBookEntry?, sell: OrderBookEntry?)] {
        let count = max(throttledBuyEntries.count, throttledSellEntries.count, 20)
        return (0..<min(count, 20)).map { i in
            let buy = i < throttledBuyEntries.count ? throttledBuyEntries[i] : nil
            let sell = i < throttledSellEntries.count ? throttledSellEntries[i] : nil
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
    
    var throttledBuyCumulativeVolumes: [Double] {
        var result: [Double] = []
        var total = 0.0
        for entry in throttledBuyEntries {
            total += entry.size
            result.append(total)
        }
        return result
    }
    var throttledSellCumulativeVolumes: [Double] {
        var result: [Double] = []
        var total = 0.0
        for entry in throttledSellEntries {
            total += entry.size
            result.append(total)
        }
        return result
    }
    var throttledMaxBuyCumulativeVolume: Double {
        throttledBuyCumulativeVolumes.max() ?? 1.0
    }
    var throttledMaxSellCumulativeVolume: Double {
        throttledSellCumulativeVolumes.max() ?? 1.0
    }

}
