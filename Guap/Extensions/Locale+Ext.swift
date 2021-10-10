//
//  Locale+Ext.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/10/21.
//

import Foundation

extension Locale {
  
  func fromCurrencyCode(_ currencyCode: String, cache: inout [String: Locale]?) -> Locale? {
    // Matches a given Locale to a valid ISO-4217 currency code
    // Can be given an optional cache to store previous matches, though that does make this function "impure"
    // Given that this computation can be expensive, we're ok with that
    
    // In the event a cache is provided, check if the value exsists within it already
    if let isCached = cache?[currencyCode] {
      return isCached
    }
    
    let ids = Locale.availableIdentifiers
    var matches = [Locale]()
    
    // Obtain matches
    for id in ids {
      let tempLocale = Locale.init(identifier: id)
      let tempCode = tempLocale.currencyCode
      
      if (tempCode == currencyCode) {
        matches.append(tempLocale)
      }
    }
    
    guard matches.count > 0 else { return nil }
    
    // Sort matches and return first the first match
    let matchedLocale = matches.sorted { return $0.identifier < $1.identifier }.first
    
    // If cache is provided, cache this match
    cache?[currencyCode] = matchedLocale
    
    return matchedLocale
  }
  
}
