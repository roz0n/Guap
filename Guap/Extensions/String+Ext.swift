//
//  String+Ext.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/10/21.
//

import Foundation

extension String {
  
  func convertToDecimal() -> Decimal? {
    let formatter = NumberFormatter()
    
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    
    if let number = formatter.number(from: self) {
      return number.decimalValue
    } else {
      return nil
    }
  }
  
  func convertFromCurrencyToDecimal(with locale: Locale) -> Decimal? {
    let formatter = NumberFormatter()
    
    formatter.locale = locale
    formatter.numberStyle = .currency
    
    if let number = formatter.number(from: self) {
      return number.decimalValue
    } else {
      return nil
    }
  }
  
}
