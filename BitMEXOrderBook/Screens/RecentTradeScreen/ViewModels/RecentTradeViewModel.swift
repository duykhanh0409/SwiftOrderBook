//
//  OrderBookViewModel.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//
import Combine
import Foundation

class RecentTradesViewModel: ObservableObject {
    @Published var trades: [Trade] = []
    let maxTradeCount = 30
    
    func processTradeMessage(_ msg: [String: Any]) {
        guard let action = msg["action"] as? String, action == "insert",
              let dataArr = msg["data"] as? [[String: Any]] else { return }
        
        var newTrades: [Trade] = []
        for entry in dataArr {
            if let id = entry["trdMatchID"] as? String,
               let side = entry["side"] as? String,
               let price = entry["price"] as? Double,
               let size = entry["size"] as? Double,
               let ts = entry["timestamp"] as? String {
                
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                if let date = dateFormatter.date(from: ts) {
                    newTrades.append(Trade(id: id, side: side, price: price, size: size, timestamp: date))
                }
            }
        }
        // Combine and sort by timestamp (descending)
        let combined = (newTrades + trades)
            .sorted { $0.timestamp > $1.timestamp }
            .prefix(maxTradeCount)
        DispatchQueue.main.async {
            self.trades = Array(combined)
        }
    }
    
    func reset() {
        trades = []
    }
}
