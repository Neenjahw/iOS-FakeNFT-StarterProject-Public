import Foundation

struct Nft: Decodable {
    let id, name, author: String
    let images: [URL]
    let rating: Int
    let price: Float
}
