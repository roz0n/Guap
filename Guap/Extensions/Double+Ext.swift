//
//  Double+Ext.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/10/21.
//

import Foundation

extension Decimal {
  
  func asCurrencyString(with locale: Locale) -> String? {
    // Formats a double to a currency string based on a given Locale
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .currency
    formatter.locale = locale
    formatter.roundingMode = .down
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    
    formatter.usesGroupingSeparator = true
    formatter.alwaysShowsDecimalSeparator = true
    formatter.allowsFloats = true
    formatter.generatesDecimalNumbers = true
    
    return formatter.string(from: self as NSDecimalNumber)
  }
  
}
