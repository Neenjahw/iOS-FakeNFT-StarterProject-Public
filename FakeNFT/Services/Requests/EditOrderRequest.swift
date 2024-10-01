import Foundation

struct EditOrderDtoObject: Dto {
    let nfts: [String]?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case nfts = "nfts"
        case id = "id"
    }
    
    func asDictionary() -> [String : String] {
        var dict: [String : String] = [:]
        if let nfts {
            if nfts.isEmpty {
                dict[CodingKeys.nfts.rawValue] = "null"
            } else {
                var increment = 0
                for id in nfts {
                    dict["nfts + \(increment)"] = id
                    increment += 1
                }
            }
        }
        if let id {
            dict[CodingKeys.id.rawValue] = id
        }
        return dict
    }
}
