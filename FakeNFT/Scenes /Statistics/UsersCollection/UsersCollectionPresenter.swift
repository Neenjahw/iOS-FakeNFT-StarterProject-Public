import Foundation

protocol UsersCollectionPresenterProtocol: AnyObject {
    func viewDidLoad(with userNFTs: [String])
    func loadNFTs()
    func getNFT() -> [NFTModel]
}

final class UsersCollectionPresenter: UsersCollectionPresenterProtocol {
    
    private let statisticsService = StatisticsNetworkService.shared
    weak var view: UsersCollectionView?
    private var nftId: [String] = []
    private var nft: [NFTModel] = []
    private var state = LoadingState.notStarted {
        didSet {
            handleStateChange()
        }
    }
    
    func attachView(_ view: UsersCollectionView) {
        self.view = view
    }
    
    func viewDidLoad(with userNftIds: [String]) {
        self.nftId = userNftIds
        state = .loadingData
    }
    
    func loadNFTs() {
        statisticsService.fetchNFT { [weak self] (response: Result<[NFTModel], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                self.nft = body
                self.state = .dataLoaded
            case .failure:
                self.state = .errorOccurred
            }
        }
    }
    
    func getNFT() -> [NFTModel] {
        return nft.filter { nftId.contains($0.id) }
    }
    
    private func handleStateChange() {
        switch state {
        case .notStarted:
            assertionFailure("Can't move to notStarted state")
        case .loadingData:
            view?.showLoadingIndicator()
            loadNFTs()
        case .dataLoaded:
            view?.hideLoadingIndicator()
            view?.updateNFTCollectionView()
        case .errorOccurred:
            view?.hideLoadingIndicator()
            view?.showErrorAlert()
        }
    }
}

