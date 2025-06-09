//
//  WebSocketManager_Tests.swift
//  BitMEXOrderBookTests
//
//  Created by Khanh Nguyen on 9/6/25.
//

import Testing
@testable import BitMEXOrderBook
import Foundation


final class MockOrderBookViewModel: OrderBookViewModel {
    var didProcessOrderBook = false
    override func processOrderBookL2Message(_ msg: [String : Any]) {
        didProcessOrderBook = true
    }
}

final class MockRecentTradesViewModel: RecentTradesViewModel {
    var didProcessTrade = false
    override func processTradeMessage(_ msg: [String : Any]) {
        didProcessTrade = true
    }
}

struct BitMEXOrderBookTests {
    @Test
    func testOrderBookMessageRoutesToOrderBookViewModel() async throws {
        let mockOrderBookVM = MockOrderBookViewModel()
        let mockRecentTradesVM = MockRecentTradesViewModel()
        let manager = WebSocketManager(
            orderBookViewModel: mockOrderBookVM,
            recentTradesViewModel: mockRecentTradesVM,
            urlSession: .shared
        )
        
        let json: [String: Any] = [
            "table": "orderBookL2",
            "data": []
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        manager.handle(data: data)
        
        #expect(mockOrderBookVM.didProcessOrderBook == true)
        #expect(mockRecentTradesVM.didProcessTrade == false)
    }
    
    @Test
    func testTradeMessageRoutesToRecentTradesViewModel() async throws {
        
        let mockOrderBookVM = MockOrderBookViewModel()
        let mockRecentTradesVM = MockRecentTradesViewModel()
        let manager = WebSocketManager(
            orderBookViewModel: mockOrderBookVM,
            recentTradesViewModel: mockRecentTradesVM,
            urlSession: .shared
        )
        
        let json: [String: Any] = [
            "table": "trade",
            "data": []
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        manager.handle(data: data)
        
        #expect(mockOrderBookVM.didProcessOrderBook == false)
        #expect(mockRecentTradesVM.didProcessTrade == true)
    }
}
