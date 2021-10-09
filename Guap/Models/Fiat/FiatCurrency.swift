//
//  FiatCurrency.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/7/21.
//

import Foundation

struct FiatCurrency: Codable {
  var iso4217: String
  var iso31661: String?
  var currencyName: String
  var countryName: String
}
