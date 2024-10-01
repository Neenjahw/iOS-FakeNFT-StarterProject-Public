//
//  OrderService.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 10.09.2024.
//

import UIKit

final class OrderService {
    private let baseUrl = RequestConstants.baseURL
    private let token = RequestConstants.token
    
    func fetchOrderNfts(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: APIEndpoint.orders.url(baseUrl: baseUrl)) else { return }
        
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
                    let orderResponce = try JSONDecoder().decode(Order.self, from: data)
                    completion(.success(orderResponce.nfts))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchNftDetails(for id: String, completion: @escaping (Result<NftDetail, Error>) -> Void) {
        guard let url = URL(string: "\(APIEndpoint.nft.url(baseUrl: baseUrl))\(id)") else { return }
        
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
                    let nftDetailResponse = try JSONDecoder().decode(NftDetail.self, from: data)
                    completion(.success(nftDetailResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func convertToCartNft(from nftDetail: NftDetail, completion: @escaping (CartNft?) -> Void) {
        guard let imageUrlString = nftDetail.images.first,
              let imageUrl = URL(string: imageUrlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            let cartNft = CartNft(name: nftDetail.name,
                                  image: image,
                                  rating: nftDetail.rating,
                                  price: nftDetail.price,
                                  id: nftDetail.id)
            
            completion(cartNft)
            
        }.resume()
    }
    
    func deleteNftRequest(withId id: String, from data: [CartNft], completion: @escaping (Result<[CartNft], Error>) -> Void) {
        let updateData = data.filter { $0.id != id }
        
        guard let postData = prepareParametrs(for: updateData) else {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        guard let url = URL(string: APIEndpoint.orders.url(baseUrl: baseUrl)) else {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.accept.rawValue)
        request.addValue(HTTPHeaderValue.urlEncoded.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.addValue(token, forHTTPHeaderField: HTTPHeaderField.token.rawValue)
        
        request.httpMethod = "PUT"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }
            
            completion(.success(updateData))
        }
        task.resume()
    }
    
    func cleaningCart(completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters = ""
        let postData = parameters.data(using: .utf8)
        
        guard let url = URL(string: APIEndpoint.orders.url(baseUrl: baseUrl)) else {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.accept.rawValue)
        request.addValue(HTTPHeaderValue.urlEncoded.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.addValue(token, forHTTPHeaderField: HTTPHeaderField.token.rawValue)

        request.httpMethod = "PUT"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }
            
            completion(.success(()))
        }
        task.resume()
    }
    
    private func prepareParametrs(for data: [CartNft]) -> Data? {
        let parametrs = data.map { "nfts=\($0.id)" }.joined(separator: "&")
        return parametrs.data(using: .utf8)
    }
}
