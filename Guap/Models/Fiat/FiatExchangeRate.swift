//
//  FiatExchangeRate.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/9/21.
//

import Foundation

// MARK: - Data Objects

struct FiatExchangeRateBody: Codable {
  var baseCode: String
  var targetCode: String
}

struct FiatExchangeRateData: Codable {
  var baseCode: String
  var targetCode: String
  var conversionRate: Decimal
}

// MARK: - API Responses

struct FiatExchangeRateResponse: Codable {
  var success: Bool
  var data: FiatExchangeRateData
  var error: Bool?
}
