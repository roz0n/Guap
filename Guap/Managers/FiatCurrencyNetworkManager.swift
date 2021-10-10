//
//  FiatCurrencyNetworkManager.swift
//  Guap
//
//  Created by Arnaldo Rozon on 10/7/21.
//

import Foundation

class FiatCurrencyNetworkManager {
  
  // MARK: - Types
  
  enum HTTPVerbs: String {
    case get = "GET"
    case post = "POST"
  }
  
  enum HTTPHeaderFields: String {
    case contentType = "content-type"
  }
  
  enum HTTPHeaderValues: String {
    case json = "application/json"
  }
  
  enum NetworkManagerErrors: String, Error {
    case sessionError = "URL Session error"
    case networkError = "Received non-200 response from API"
    case dataError = "Received malformed data from API"
    case decodeError = "Error decoding JSON response from API"
  }
  
  // MARK: - Properties
  
  private lazy var encoder = JSONEncoder()
  
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
  
  private func getPostUrlRequest<T: Encodable>(url: URL, body: T, encoder: JSONEncoder) -> URLRequest? {
    guard let requestBody = try? encoder.encode(body) else {
      return nil
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = HTTPVerbs.post.rawValue
    request.setValue(HTTPHeaderValues.json.rawValue, forHTTPHeaderField: HTTPHeaderFields.contentType.rawValue)
    request.httpBody = requestBody
    
    return request
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
  
  // MARK: - Networking
  
  func fetchPairExchangeRate(baseCode: String, targetCode: String, completion: @escaping (_ responseData: Result<FiatExchangeRateResponse, NetworkManagerErrors>) -> Void) {
    guard let requestUrl = URL(string: "https://8c4e-2601-241-8c01-2ff0-3106-9534-bad8-f013.ngrok.io/fiat/pair") else {
      return
    }
    
    guard let request = getPostUrlRequest(url: requestUrl, body: FiatExchangeRateBody(baseCode: baseCode, targetCode: targetCode), encoder: encoder) else {
      return
    }
    
    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      if let _ = error {
        completion(.failure(.sessionError))
        return
      }
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.networkError))
        return
      }
      
      guard let data = data else {
        completion(.failure(.dataError))
        return
      }
      
      do {
        let decodedData = try self?.decoder.decode(FiatExchangeRateResponse.self, from: data)
        
        guard let decodedData = decodedData else {
          throw NetworkManagerErrors.dataError
        }
        
        completion(.success(decodedData))
      } catch let error {
        print("Error: unable to decode fiat exchange rate response")
        print(error)
        completion(.failure(.decodeError))
      }
    }.resume()
  }
  
}
