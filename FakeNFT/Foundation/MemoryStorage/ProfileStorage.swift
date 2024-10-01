import Foundation

protocol ProfileStorage: AnyObject {
    func saveProfile(_ profile: ProfileData)
    func getProfileData() -> ProfileData?
}

final class ProfileStorageImpl: ProfileStorage {
    private var profile: ProfileData?
    
    private let syncQueue = DispatchQueue(label: "sync-profile-queue")
    
    func saveProfile(_ profile: ProfileData) {
        syncQueue.async { [weak self] in
            self?.profile = profile
        }
    }
    
    func getProfileData() -> ProfileData? {
        syncQueue.sync {
            profile
        }
    }
}

