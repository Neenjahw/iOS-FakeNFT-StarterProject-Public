import Foundation

struct NFTCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.Endpoints.collections)")
    }
    var dto: Dto?
}

struct NFTRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.Endpoints.nft)/\(id)")
    }
    var dto: Dto?
}

struct ProfileRequest: NetworkRequest {
    let profileId: String = "1"
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.Endpoints.profile)/\(profileId)")
    }
    var dto: Dto?
}

struct EditProfileRequest: NetworkRequest {
    let profileId: String = "1"
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.Endpoints.profile)/\(profileId)")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

struct OrderRequest: NetworkRequest {
    let orderId: String = "1"
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.Endpoints.orders)/\(orderId)")
    }
    var dto: Dto?
}

struct EditOrderRequest: NetworkRequest {
    let orderId: String = "1"
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.Endpoints.orders)/\(orderId)")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}
