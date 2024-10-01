
import UIKit

protocol NftCollectionView: AnyObject, ErrorView, LoadingView {
    func displayCells(_ cellModel: [NftCellModel], with myFavoritesNFTID: [String], and order: [String])
    func display(_ model: NftCollectionModel)
    func displayLike(_ favoritesNFTId: [String]?)
    func displayOrder(_ orderNFTId: [String]?)
}

//MARK: - NftCollectionViewController
final class NftCollectionViewController: UIViewController {
    
    //MARK: - Private Properties
    private let params: GeometricParams = {
        let params = GeometricParams(cellCount: 3,
                                     topInset: 0,
                                     leftInset: 16,
                                     bottomInset: 8,
                                     rightInset: 16,
                                     cellSpacing: 10)
        return params
    }()
    private let presenter: NftCollectionPresenter
    private var collectionModel: NftCollectionModel?
    private var nftCellModel: [NftCellModel] = []
    private var favoritesNFTId: [String] = []
    private var orderNFTId: [String] = []
    
    //MARK: - Public Properties
    lazy var activityIndicator = UIActivityIndicatorView()
    
    //MARK: - UIModels
    private lazy var backwardButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(resource: .chevron), for: .normal)
        button.addTarget(self, action: #selector(backToNftCatalogViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NftCell.self)
        collectionView.register(NftHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    //MARK: - Init
    init(presenter: NftCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
    }
    
    //MARK: - Private methods
    @objc private func backToNftCatalogViewController() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension NftCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftCellModel.isEmpty ? 0 : nftCellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let cellModel = nftCellModel[indexPath.item]
        cell.configure(cellModel, favoritesNFTId, orderNFTId)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: view.frame.width, height: 450)
        }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerView: NftHeaderCollectionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, indexPath: indexPath)
        headerView.configure(collectionModel)
        headerView.delegate = self
        return headerView
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: params.topInset, left: params.leftInset, bottom: params.bottomInset, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 192)
    }
}

//MARK: - NftCatalogView
extension NftCollectionViewController: NftCollectionView {
    func displayOrder(_ orderNFTId: [String]?) {
        self.orderNFTId = orderNFTId ?? [""]
        nftsCollectionView.reloadData()
    }
    
    func displayLike(_ myFavoritesNFTID: [String]?) {
        self.favoritesNFTId = myFavoritesNFTID ?? [""]
        nftsCollectionView.reloadData()
    }
    
    func display(_ model: NftCollectionModel) {
        self.collectionModel = model
        nftsCollectionView.reloadData()
    }
    
    func displayCells(_ cellModel: [NftCellModel], with myFavoritesNFTID: [String], and order: [String]) {
        guard !cellModel.isEmpty else { return }
        self.favoritesNFTId = myFavoritesNFTID
        self.orderNFTId = order
        nftCellModel.append(contentsOf: cellModel)
        nftsCollectionView.reloadData()
    }
}

//MARK: - NftCellDelegate
extension NftCollectionViewController: NftCellDelegate {
    func nftCellDidUpdateLikeStatus(nftId: String) {
        presenter.updateLikeStatus(for: nftId)
    }
    
    func nftCellDidUpdateOrderStatus(nftId: String) {
        presenter.updateOrderStatus(for: nftId)
    }
}

//MARK: - NftHeaderCollectionViewDelegate
extension NftCollectionViewController: NftHeaderCollectionViewDelegate {
    func transitionToAuthorPage() {
        let authorPageViewController = AuthorPageViewController()
        navigationController?.pushViewController(authorPageViewController, animated: true)
    }
}

//MARK: - AutoLayout
extension NftCollectionViewController {
    private func setupViews() {
        [nftsCollectionView,
         backwardButton,
         activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view?.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            nftsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
        ])
        activityIndicator.constraintCenters(to: view)
    }
}
