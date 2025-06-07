import Foundation
import Combine

class OrderBookViewModel: ObservableObject {
    @Published var buyEntries: [OrderBookEntry] = []
    @Published var sellEntries: [OrderBookEntry] = []

    // Maintain dictionaries for fast, stable updates
    private var buyDict: [Int: OrderBookEntry] = [:]
    private var sellDict: [Int: OrderBookEntry] = [:]

    // Public interface for WebSocketManager to process new messages
    func processOrderBookL2Message(_ msg: [String: Any]) {
        guard let action = msg["action"] as? String,
              let dataArr = msg["data"] as? [[String: Any]] else { return }
        for entry in dataArr {
            guard let id = entry["id"] as? Int,
                  let side = entry["side"] as? String else { continue }
            let price = entry["price"] as? Double ?? 0
            let size = entry["size"] as? Int ?? 0
            switch action {
            case "insert":
                let newEntry = OrderBookEntry(id: id, side: side, price: price, size: size)
                if side == "Buy" { buyDict[id] = newEntry }
                else { sellDict[id] = newEntry }
            case "update":
                if side == "Buy", var exist = buyDict[id] {
                    exist.size = size
                    buyDict[id] = exist
                }
                if side == "Sell", var exist = sellDict[id] {
                    exist.size = size
                    sellDict[id] = exist
                }
            case "delete":
                if side == "Buy" { buyDict.removeValue(forKey: id) }
                if side == "Sell" { sellDict.removeValue(forKey: id) }
            default:
                break
            }
        }
        // Update published properties
        buyEntries = Array(buyDict.values).sorted { $0.price > $1.price }.prefix(20).map { $0 }
        sellEntries = Array(sellDict.values).sorted { $0.price < $1.price }.prefix(20).map { $0 }
    }

    // Call this if you want to clear everything
    func reset() {
        buyDict.removeAll()
        sellDict.removeAll()
        buyEntries = []
        sellEntries = []
    }
}
