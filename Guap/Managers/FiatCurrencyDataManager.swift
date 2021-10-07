//
//  FiatCurrencyDataManager.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/7/21.
//

import Foundation

class FiatCurrencyDataManager {
  
  // MARK: - Properties
  
  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  
  // MARK: - Helpers
  
  private func getCurrenciesData() -> Data? {
    do {
      guard let path = Bundle.main.path(forResource: "currencies", ofType: "json"),
            let jsonString = try String(contentsOfFile: path).data(using: .utf8) else {
              return nil
            }
      
      return jsonString
    } catch {
      print("Unable to fetch `currencies.json`")
      return nil
    }
  }
  
  // MARK: -
  
  func getCurrenciesList(completion: @escaping (_ data: [FiatCurrency]?) -> Void) {
    guard let data = getCurrenciesData() else {
      completion(nil)
      return
    }
    
    do {
      let decodedData = try decoder.decode([FiatCurrency].self, from: data)
      completion(decodedData)
    } catch {
      completion(nil)
      return
    }
  }
  
}
