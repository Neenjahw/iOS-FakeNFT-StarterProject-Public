import Foundation

struct EditProfileDtoObject: Dto {
    let name: String?
    let description: String?
    let website: String?
    let avatar: String?
    let likes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case website = "website"
        case avatar = "avatar"
        case likes = "likes"
    }
    
    func asDictionary() -> [String : String] {
        var dict: [String : String] = [:]
        if let name {
            dict[CodingKeys.name.rawValue] = name
        }
        if let description {
            dict[CodingKeys.description.rawValue] = description
        }
        if let website {
            dict[CodingKeys.website.rawValue] = website
        }
        if let avatar {
            dict[CodingKeys.avatar.rawValue] = avatar
        }
        if let likes {
            if likes.isEmpty {
                dict[CodingKeys.likes.rawValue] = "null"
            } else {
                var increment = 0
                for id in likes {
                    dict["likes + \(increment)"] = id
                    increment += 1
                }
            }
        }
        return dict
    }
}
