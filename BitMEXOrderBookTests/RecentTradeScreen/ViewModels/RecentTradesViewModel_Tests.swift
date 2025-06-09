//
//  RecentTradesViewModel_Tests.swift
//  BitMEXOrderBookTests
//
//  Created by Khanh Nguyen on 9/6/25.
//

import XCTest
import Combine
@testable import BitMEXOrderBook

final class RecentTradesViewModel_Tests: XCTestCase {
    var viewModel: RecentTradesViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = RecentTradesViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testProcessTradeMessage_InsertsTradeAndSortsDescending() {
        let exp = expectation(description: "Trades are published and sorted")
        let trade1Date = Date()
        let trade2Date = trade1Date.addingTimeInterval(1)
        
       
        viewModel.$trades
            .dropFirst()
            .sink { trades in
                    exp.fulfill()
            }
            .store(in: &cancellables)
        
        let tradeMsg: [String: Any] = [
            "action": "insert",
            "data": [
                [
                    "trdMatchID": "a1",
                    "side": "Buy",
                    "price": 100.0,
                    "size": 1.0,
                    "timestamp": ISO8601DateFormatter().string(from: trade1Date)
                ],
                [
                    "trdMatchID": "a2",
                    "side": "Sell",
                    "price": 101.0,
                    "size": 2.0,
                    "timestamp": ISO8601DateFormatter().string(from: trade2Date)
                ]
            ]
        ]
        viewModel.processTradeMessage(tradeMsg)
        
        wait(for: [exp], timeout: 2.0)
    }
    
}
