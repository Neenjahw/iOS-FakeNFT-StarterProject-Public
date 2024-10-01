//
//  Order.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 10.09.2024.
//

import Foundation

struct Order: Decodable {
    let nfts: [String]
    let id: String
}
