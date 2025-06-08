//
//  Double+Ext.swift
//  BitMEXOrderBook
//
//  Created by Khanh Nguyen on 7/6/25.
//

import Foundation

extension Double {
    func formattedWithSeparator(decimalPlaces: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func qtyString(_ qty: Double) -> String {
        let normalizedQty = qty / 100000.0
        return String(format: "%.4f", normalizedQty)
    }
    
}
