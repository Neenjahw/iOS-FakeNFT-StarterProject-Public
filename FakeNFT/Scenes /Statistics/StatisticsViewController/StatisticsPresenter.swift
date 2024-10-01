import Foundation

protocol StatisticsPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func fetchUsers()
    func retrieveUsers() -> [User]
    func sortUsers(by option: StatisticsPresenter.SortOption)
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    enum SortOption: String {
        case name
        case rating
    }
    
    private let statisticsService = StatisticsNetworkService.shared
    private var users: [User] = []
    private var state = LoadingState.notStarted {
        didSet {
            handleStateChange()
        }
    }
    
    weak var view: StatisticsView?
    private let servicesAssembly: ServicesAssembly
    private let sortKey = "selectedSortOption"
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func attachView(_ view: StatisticsView) {
        self.view = view
    }
    
    func viewDidLoad() {
        state = .loadingData
    }
    
    func fetchUsers() {
        statisticsService.fetchUsers { [weak self] (response: Result<[User], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                self.users = body
                if let savedSortOption = self.loadSortOption() {
                    self.sortUsers(by: savedSortOption)
                } else {
                    self.state = .dataLoaded
                }
            case .failure:
                self.state = .errorOccurred
            }
        }
    }
    
    func retrieveUsers() -> [User] {
        users
    }
    
    func sortUsers(by option: SortOption) {
        saveSortOption(option)
        switch option {
        case .name:
            users.sort { $0.name < $1.name }
        case .rating:
            users.sort { $0.nfts.count > $1.nfts.count }
        }
        state = .dataLoaded
    }
    
    private func saveSortOption(_ option: SortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortKey)
    }
    
    private func loadSortOption() -> SortOption? {
        guard let sortOptionRawValue = UserDefaults.standard.string(forKey: sortKey),
              let sortOption = SortOption(rawValue: sortOptionRawValue) else {
            return nil
        }
        return sortOption
    }
    
    private func handleStateChange() {
        view?.hideLoadingIndicator()
        
        switch state {
        case .notStarted:
            assertionFailure("Can't move to notStarted state")
        case .loadingData:
            view?.showLoadingIndicator()
            fetchUsers()
        case .dataLoaded:
            view?.updateTableView()
        case .errorOccurred:
            view?.showErrorAlert()
        }
    }
}
