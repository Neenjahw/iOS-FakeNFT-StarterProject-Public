import Foundation

typealias EditProfileCompletion = (Result<ProfileData, Error>) -> Void

protocol EditProfileServices {
    func sendEditProfileRequest(
        name: String?,
        description: String?,
        website: String?,
        avatar: String?,
        likes: [String]?,
        completion: @escaping EditProfileCompletion
    )
}

final class EditProfileServicesImpl: EditProfileServices {
    private let networkClient: NetworkClient
    private let profileStorage: ProfileStorage
    
    init(networkClient: NetworkClient, profileStorage: ProfileStorage) {
        self.networkClient = networkClient
        self.profileStorage = profileStorage
    }
    
    func sendEditProfileRequest(
        name: String?,
        description: String?,
        website: String?,
        avatar: String?,
        likes: [String]?,
        completion: @escaping EditProfileCompletion
    ) {
        let dto = EditProfileDtoObject(
            name: name,
            description: description,
            website: website,
            avatar: avatar,
            likes: likes
        )
        let request = EditProfileRequest(dto: dto)
        networkClient.send(request: request, type: ProfileData.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profileStorage.saveProfile(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
