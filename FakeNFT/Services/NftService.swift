import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias NftCollectionsCompletion = (Result<[NftCollection], Error>) -> Void
typealias NftCollectionCompletion = (Result<NftCollection, Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadNftCollections(completion: @escaping NftCollectionsCompletion)
    func loadNftCollection(id: String, completion: @escaping NftCollectionCompletion)
}

final class NftServiceImpl: NftService {
    
    private let networkClient: NetworkClient
    private let storage: NftStorage
    private let collectionsStorage: NftCollectionsStorage
    
    init(networkClient: NetworkClient, storage: NftStorage, collectionsStorage: NftCollectionsStorage) {
        self.storage = storage
        self.collectionsStorage = collectionsStorage
        self.networkClient = networkClient
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNftCollection(id: String, completion: @escaping NftCollectionCompletion) {
        if let nftCollections = collectionsStorage.getNftCollections(with: id) {
            completion(.success(nftCollections))
            return
        }
        let request = NFTCollectionsRequest()
        networkClient.send(request: request, type: NftCollection.self) { [weak collectionsStorage] result in
            switch result {
            case .success(let nftCollection):
                collectionsStorage?.saveNftCollection(nftCollection)
                completion(.success(nftCollection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNftCollections(completion: @escaping NftCollectionsCompletion) {
        if let nftCollections = collectionsStorage.getAllNftCollections(), !nftCollections.isEmpty {
            completion(.success(nftCollections))
        } else {
            let request = NFTCollectionsRequest()
            networkClient.send(request: request, type: [NftCollection].self) { [weak collectionsStorage] result in
                switch result {
                case .success(let nftCollections):
                    collectionsStorage?.saveNftCollections(nftCollections)
                    completion(.success(nftCollections))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}
