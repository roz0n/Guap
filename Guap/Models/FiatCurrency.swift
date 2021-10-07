//
//  FiatCurrency.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/7/21.
//

import Foundation

/**
 "iso4217": "AED",
 "iso3166-1": "United Arab Emirates",
 "currencyName": "UAE Dirham",
 "countryName": "United Arab Emirates"
 */

struct FiatCurrency: Codable {
  
  var iso4217: String
  var iso31661: String
  var currencyName: String
  var countryName: String
  
}
