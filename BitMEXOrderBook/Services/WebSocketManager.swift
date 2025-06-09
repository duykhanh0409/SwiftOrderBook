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
    private(set) var webSocketTask: URLSessionWebSocketTask?
    let orderBookViewModel: OrderBookViewModel
    let recentTradesViewModel: RecentTradesViewModel
    private let urlSession: URLSession
    private let urlString: String
    
    private var cancellables = Set<AnyCancellable>()
    
    init(orderBookViewModel: OrderBookViewModel = .shared,
         recentTradesViewModel: RecentTradesViewModel = .shared,
         urlSession: URLSession = .shared,
         urlString: String = BitMEXConstants.webSocketURL) {
        self.orderBookViewModel = orderBookViewModel
        self.recentTradesViewModel = recentTradesViewModel
        self.urlSession = urlSession
        self.urlString = urlString
    }
    
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
            "args": [BitMEXConstants.orderBookChannel]
        ]
        send(json: dict)
    }
    
    private func subscribeTrades() {
        let dict: [String: Any] = [
            "op": "subscribe",
            "args": [BitMEXConstants.tradeChannel]
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
        guard let data = text.data(using: .utf8) else { return }
    
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let table = json["table"] as? String {
            
            if table == "orderBookL2" {
                orderBookViewModel.processOrderBookL2Message(json)
            }
            
            if table == "trade" {
                recentTradesViewModel.processTradeMessage(json)
            }
        }
    }
    
    internal func handle(data: Data) {
        if let text = String(data: data, encoding: .utf8) {
            handle(text: text)
        }
    }
}
