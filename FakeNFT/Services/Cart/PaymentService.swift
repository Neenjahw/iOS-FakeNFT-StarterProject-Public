//
//  PaymentService.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 16.09.2024.
//

import UIKit

final class PaymentService {
    private let baseUrl = RequestConstants.baseURL
    private let token = RequestConstants.token
    
    func fetchCryptocurrcencies(completion: @escaping (Result<[Cryptocurrency], Error>) -> Void) {
        guard let url = URL(string: APIEndpoint.currencies.url(baseUrl: baseUrl)) else {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.accept.rawValue)
        request.addValue(token, forHTTPHeaderField: HTTPHeaderField.token.rawValue)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        var cryptocurrencies: [Cryptocurrency] = []
                        
                        for json in jsonArray {
                            if let currencyName = json["title"] as? String,
                               let currencySymbol = json["name"] as? String,
                               let imageURLString = json["image"] as? String,
                               let id = json["id"] as? String,
                               let imageURL = URL(string: imageURLString),
                               let imageData = try? Data(contentsOf: imageURL),
                               let image = UIImage(data: imageData) {
                                
                                let cryptocurrency = Cryptocurrency(currencyName: currencyName, currencySymbol: currencySymbol, image: image, id: id)
                                cryptocurrencies.append(cryptocurrency)
                            }
                        }
                        completion(.success(cryptocurrencies))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func payForOrder(cryptocurrencyIndex: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(APIEndpoint.payment.url(baseUrl: baseUrl))\(cryptocurrencyIndex)") else {
            completion(.failure(NSError(domain: "", code: -1)))
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.accept.rawValue)
        request.addValue(token, forHTTPHeaderField: HTTPHeaderField.token.rawValue)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1)))
                print("No data received")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let success = jsonResponse["success"] as? Bool {
                    
                    completion(.success(success))
                } else {
                    completion(.failure(NSError(domain: "", code: -1)))
                    print("Invalid response format")
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
