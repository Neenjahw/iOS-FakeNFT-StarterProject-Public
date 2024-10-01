//
//  APIEndpoint.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 23.09.2024.
//

import Foundation

enum APIEndpoint: String {
    case orders = "/api/v1/orders/1"
    case nft = "/api/v1/nft/"
    case currencies = "/api/v1/currencies"
    case payment = "/api/v1/orders/1/payment/"
    
    func url(baseUrl: String) -> String {
        return "\(baseUrl)\(self.rawValue)"
    }
}
