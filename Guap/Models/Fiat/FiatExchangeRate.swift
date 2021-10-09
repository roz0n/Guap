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

struct FiatExchangeRateResponse: Codable {
  var baseCode: String
  var targetCode: String
  var conversionRate: Decimal
}

// MARK: - API Responses

struct FiatExchangeRateResponseData: Codable {
  var success: Bool
  var data: FiatExchangeRateResponse
  var error: Bool?
}
