
import Foundation

struct NftCollection: Decodable {
    let name: String
    let cover: URL
    let id: String
    let description: String
    let author: String
    let nfts: [String]
}
