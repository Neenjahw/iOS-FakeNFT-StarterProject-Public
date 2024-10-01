//
//  NftDetail.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 10.09.2024.
//

import Foundation

struct NftDetail: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let id: String
}
