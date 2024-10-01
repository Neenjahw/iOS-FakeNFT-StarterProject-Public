//
//  HTTPHeaders.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 23.09.2024.
//

import Foundation

enum HTTPHeaderField: String {
    case accept = "Accept"
    case contentType = "Content-Type"
    case token = "X-Practicum-Mobile-Token"
}

enum HTTPHeaderValue: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
}
