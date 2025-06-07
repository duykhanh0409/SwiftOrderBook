//
//  ContentView.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import SwiftUI

enum Tab {
    case orderBook, recentTrades
}


struct ContentView: View {
    @State private var selectedTab: Tab = .orderBook
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                tabButton(title: "Order Book", tab: .orderBook)
                Spacer()
                tabButton(title: "Recent Trades", tab: .recentTrades)
                Spacer()
            }
            .background(Color(.systemGray6))
            .padding(.top, 8)
            .padding(.bottom, 4)
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.gray.opacity(0.2)),
                alignment: .bottom
            )
            .padding(.bottom, 4)
            
            Divider()
            if selectedTab == .orderBook {
                OrderBooksView()
            } else {
                RecentTradesView()
            }
        }
        .onAppear {
            WebSocketManager.shared.connect()
        }
        .onDisappear {
            WebSocketManager.shared.disconnect()
        }
    }
    
    @ViewBuilder
    func tabButton(title: String, tab: Tab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 2) {
                Text(title)
                    .fontWeight(selectedTab == tab ? .bold : .regular)
                    .foregroundColor(selectedTab == tab ? Color.accentColor : .secondary)
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(selectedTab == tab ? Color.accentColor : .clear)
            }
        }
        .animation(.easeInOut, value: selectedTab)
    }
}

#Preview {
    ContentView()
}
