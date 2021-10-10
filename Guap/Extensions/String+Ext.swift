//
//  String+Ext.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/10/21.
//

import Foundation

extension String {
  
  func asDecimal() -> Decimal? {
    let formatter = NumberFormatter()
    
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    
    if let number = formatter.number(from: self) {
      return number.decimalValue
    } else {
      return nil
    }
  }
  
}
