//
//  ProfileService.swift
//  FakeNFT
//
//  Created by gimon on 10.09.2024.
//

import Foundation

typealias ProfileCompletion = (Result<ProfileData, Error>) -> Void

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func getProfileStorage() -> ProfileStorage
}

final class ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient
    private let profileStorage: ProfileStorage
    
    init(networkClient: NetworkClient, profileStorage: ProfileStorage) {
        self.profileStorage = profileStorage
        self.networkClient = networkClient
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        if let profile = profileStorage.getProfileData() {
            completion(.success(profile))
            return
        }
        
        let request = ProfileRequest()
        networkClient.send(request: request, type: ProfileData.self) {[weak self] result in
            switch result {
            case .success(let profile):
                self?.profileStorage.saveProfile(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getProfileStorage() -> ProfileStorage {
        profileStorage
    }
}
