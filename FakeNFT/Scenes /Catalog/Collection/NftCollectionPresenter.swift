
import Foundation

//MARK: - Protocol
protocol NftCollectionPresenter {
    func viewDidLoad()
    func updateLikeStatus(for likeId: String)
    func updateOrderStatus(for orderId: String)
}

//MARK: - State
enum NftCollectionState {
    case initial, loading, failed(Error), collectionData(NftCollection), nftData(Nft)
}

//MARK: - NftCatalogPresenterImpl
final class NftCollectionPresenterImpl: NftCollectionPresenter {
    
    //MARK: - Private Properties
    private let service: NftService
    private let editProfileServices: EditProfileServices
    private let profileService: ProfileService
    private let orderServices: OrderServices
    private let editOrderService: EditOrderService
    private var state = NftCollectionState.initial {
        didSet {
            stateDidChanged()
        }
    }
    private let nftCollectionId: String
    private var nftIds: [String] = []
    private var nftCellModels: [NftCellModel] = []
    private var favoritesNFTId: [String] = []
    private var orderNFTId: [String] = []
    
    //MARK: - Public Properties
    weak var view: NftCollectionView?
    
    //MARK: - Init
    init(service: NftService,
         editProfileServices: EditProfileServices,
         profileService: ProfileService,
         orderService: OrderServices,
         editOrderService: EditOrderService,
         nftCollectionId: String) {
        self.service = service
        self.editProfileServices = editProfileServices
        self.profileService = profileService
        self.nftCollectionId = nftCollectionId
        self.orderServices = orderService
        self.editOrderService = editOrderService
    }
    
    //MARK: - Public Functions
    func viewDidLoad() {
        state = .loading
    }
    
    //MARK: - Private Functions
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNftCollections(with: nftCollectionId)
            loadFavoritesNfts()
            loadOrder()
        case .collectionData(let nftCollection):
            view?.hideLoading()
            let collectionModel = NftCollectionModel(
                name: nftCollection.name,
                cover: nftCollection.cover,
                id: nftCollection.id,
                description: nftCollection.description,
                author: nftCollection.author,
                nfts: nftCollection.nfts)
            view?.display(collectionModel)
        case.nftData(let nft):
            let nftCellModel = NftCellModel(
                name: nft.name,
                images: nft.images,
                rating: nft.rating,
                price: nft.price,
                id: nft.id)
            loadFavoritesNfts()
            loadOrder()
            view?.displayCells([nftCellModel], with: favoritesNFTId, and: orderNFTId)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }
    
    private func loadNftCollections(with id: String) {
        service.loadNftCollection(id: id) { [weak self] result in
            switch result {
            case .success(let nftCollection):
                nftCollection.nfts.forEach { nftId in
                    self?.loadNft(with: nftId)
                    self?.state = .collectionData(nftCollection)
                }
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func loadNft(with id: String) {
        service.loadNft(id: id) { [weak self] result in
            switch result {
            case .success(let nft):
                let nftCellModel = NftCellModel(
                    name: nft.name,
                    images: nft.images,
                    rating: nft.rating,
                    price: nft.price,
                    id: nft.id
                )
                self?.nftCellModels.append(nftCellModel)
                self?.state = .nftData(nft)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func loadFavoritesNfts() {
        profileService.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.favoritesNFTId = profile.likes
            case.failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func loadOrder() {
        orderServices.loadOrder { [weak self] result in
            switch result {
            case .success(let order):
                self?.orderNFTId = order.nfts
            case.failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    func updateOrderStatus(for orderId: String) {
        if let index = orderNFTId.firstIndex(of: orderId) {
            orderNFTId.remove(at: index)
        } else {
            orderNFTId.append(orderId)
        }
        orderNFTId = Array(Set(orderNFTId))
        editOrderService.sendEditOrderRequest(
            nfts: orderNFTId,
            id: nil) { [weak self] result in
                switch result {
                case .success(let order):
                    self?.orderNFTId = order.nfts
                    self?.view?.displayOrder(self?.orderNFTId)
                case.failure(let error):
                    self?.state = .failed(error)
                }
            }
    }
    
    func updateLikeStatus(for likeId: String) {
        if let index = favoritesNFTId.firstIndex(of: likeId) {
            favoritesNFTId.remove(at: index)
        } else {
            favoritesNFTId.append(likeId)
        }
        favoritesNFTId = Array(Set(favoritesNFTId))
        editProfileServices.sendEditProfileRequest(
            name: nil,
            description: nil,
            website: nil,
            avatar: nil,
            likes: favoritesNFTId
        ) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.favoritesNFTId = profile.likes
                self?.view?.displayLike(self?.favoritesNFTId)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
