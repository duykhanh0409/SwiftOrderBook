//
//  WebSocketManager.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import Foundation
import Combine

class WebSocketManager: ObservableObject {
    static let shared = WebSocketManager()
    private var webSocketTask: URLSessionWebSocketTask?
    let orderBookViewModel = OrderBookViewModel()
    let recentTradesViewModel = RecentTradesViewModel()
    private let urlSession = URLSession(configuration: .default)
    private let urlString = "wss://www.bitmex.com/realtime"
    
    @Published var orderBookData: [OrderBookEntry] = []
    @Published var tradesData: [Trade] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func connect() {
        guard webSocketTask == nil else { return }
        guard let url = URL(string: urlString) else { return }
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        listen()
        subscribeOrderBook()
        subscribeTrades()
    }
    
    func disconnect() {
        webSocketTask?.cancel()
        webSocketTask = nil
    }
    
    private func listen() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
            case .success(let message):
                print("WebSocket message: \(message)")
                switch message {
                case .data(let data):
                    self?.handle(data: data)
                case .string(let text):
                    self?.handle(text: text)
                @unknown default: break
                }
            }
            self?.listen()
        }
    }
    
    private func subscribeOrderBook() {
        let dict: [String: Any] = [
            "op": "subscribe",
            "args": ["orderBookL2:XBTUSD"]
        ]
        send(json: dict)
    }
    
    private func subscribeTrades() {
        let dict: [String: Any] = [
            "op": "subscribe",
            "args": ["trade:XBTUSD"]
        ]
        send(json: dict)
    }
    
    private func send(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []),
              let text = String(data: data, encoding: .utf8) else { return }
        webSocketTask?.send(.string(text)) { error in
            if let error = error {
                print("Send error: \(error)")
            }
        }
    }
    
    private func handle(text: String) {
        // Parse the incoming message to see if it's an orderBook or trade update
        guard let data = text.data(using: .utf8) else { return }
    
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let table = json["table"] as? String,
           let action = json["action"] as? String,
           let dataArr = json["data"] as? [[String: Any]] {
            
            if table == "orderBookL2" {
                orderBookViewModel.processOrderBookL2Message(json)
            }
            
            if table == "trade" {
                recentTradesViewModel.processTradeMessage(json)
            }
        }
    }
    
    private func handle(data: Data) {
        if let text = String(data: data, encoding: .utf8) {
            handle(text: text)
        }
    }
}
