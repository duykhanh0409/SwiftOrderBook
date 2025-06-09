//
//  OrderBookViewModel_Tests.swift
//  BitMEXOrderBookTests
//
//  Created by Khanh Nguyen on 9/6/25.
//

import XCTest
import Combine
@testable import BitMEXOrderBook

final class OrderBookViewModel_Tests: XCTestCase {
    var viewModel: OrderBookViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = OrderBookViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInsertBuyOrder_ThrottledEntryAppears() {
        let exp = expectation(description: "throttledBuyEntries should be updated")
        viewModel.$throttledBuyEntries
            .dropFirst()
            .sink { entries in
                if let first = entries.first {
                    XCTAssertEqual(first.price, 10.0)
                    XCTAssertEqual(first.size, 2.0)
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)
        
        let msg: [String: Any] = [
            "action": "insert",
            "data": [
                [
                    "id": 1,
                    "side": "Buy",
                    "price": 10.0,
                    "size": 2.0
                ]
            ]
        ]
        viewModel.processOrderBookL2Message(msg)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func testInsertSellOrder_ThrottledEntryAppears() {
        let exp = expectation(description: "throttledSellEntries should be updated")
        viewModel.$throttledSellEntries
            .dropFirst()
            .sink { entries in
                if let first = entries.first {
                    XCTAssertEqual(first.price, 20.0)
                    XCTAssertEqual(first.size, 3.0)
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)
        
        let msg: [String: Any] = [
            "action": "insert",
            "data": [
                [
                    "id": 10,
                    "side": "Sell",
                    "price": 20.0,
                    "size": 3.0
                ]
            ]
        ]
        viewModel.processOrderBookL2Message(msg)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testResetClearsAllEntries() {
        let exp = expectation(description: "throttledBuyEntries should be empty after reset")
        
        viewModel.$throttledBuyEntries
            .dropFirst()
            .sink { entries in
                if entries.isEmpty {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)
        
        let msg: [String: Any] = [
            "action": "insert",
            "data": [
                [
                    "id": 1,
                    "side": "Buy",
                    "price": 10.0,
                    "size": 2.0
                ]
            ]
        ]
        viewModel.processOrderBookL2Message(msg)
        viewModel.reset()
        
        wait(for: [exp], timeout: 1.0)
    }
}
