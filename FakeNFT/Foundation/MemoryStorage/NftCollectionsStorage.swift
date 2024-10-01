
import Foundation

protocol NftCollectionsStorage: AnyObject {
    func saveNftCollections(_ nftCollections: [NftCollection])
    func saveNftCollection(_ nftCollection: NftCollection)
    func getNftCollections(with id: String) -> NftCollection?
    func getAllNftCollections() -> [NftCollection]?
}

final class NftCollectionsStorageImpl: NftCollectionsStorage {
    private var storage: [String: NftCollection] = [:]
    private let syncQueue = DispatchQueue(label: "sync-nftCollections-queue")
    
    func saveNftCollections(_ nftCollections: [NftCollection]) {
        syncQueue.async { [weak self] in
            for nftCollection in nftCollections {
                self?.storage[nftCollection.id] = nftCollection
            }
        }
    }
    
    func saveNftCollection(_ nftCollection: NftCollection) {
        syncQueue.async { [weak self] in
            self?.storage[nftCollection.id] = nftCollection
        }
    }
    
    func getNftCollections(with id: String) -> NftCollection? {
        syncQueue.sync {
            storage[id]
        }
    }
    
    func getAllNftCollections() -> [NftCollection]? {
        syncQueue.sync {
            Array(storage.values)
        }
    }
}
