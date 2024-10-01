import UIKit
import ProgressHUD

final class UsersCollectionViewController: UIViewController, UsersCollectionView {
    
    private var userNFTs: [String]
    private lazy var presenter: UsersCollectionPresenterProtocol = {
        let presenter = UsersCollectionPresenter()
        presenter.attachView(self)
        return presenter
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StatisticsCollectionViewCell.self, forCellWithReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let noNFCLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Statistic.nftCollection.noNft", comment: "У пользователя еще нет NFT")
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(userNFTs: [String]) {
        self.userNFTs = userNFTs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupUI()
        presenter.viewDidLoad(with: userNFTs)
    }
    
    private func setupUI() {
        setupNaviBar()
        setupConstraints()
        view.addSubview(noNFCLabel)
        
        NSLayoutConstraint.activate([
            noNFCLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFCLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        noNFCLabel.isHidden = true
    }
    
    private func setupNaviBar() {
        title = NSLocalizedString("Statistics.Collection.title", comment: "Коллекция NFT")
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftCollectionView)
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func updateNFTCollectionView() {
        nftCollectionView.reloadData()
        
        if presenter.getNFT().isEmpty {
            noNFCLabel.isHidden = false
            nftCollectionView.isHidden = true
        } else {
            noNFCLabel.isHidden = true
            nftCollectionView.isHidden = false
        }
    }
    
    func showLoadingIndicator() {
        LoadingIndicator.show()
    }
    
    func hideLoadingIndicator() {
        LoadingIndicator.hide()
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Не удалось получить данные",
            message: nil,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        let action = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.presenter.viewDidLoad(with: self?.userNFTs ?? [])
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
}

extension UsersCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNFT().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier, for: indexPath) as? StatisticsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let nft = presenter.getNFT()[indexPath.row]
        cell.configure(for: nft)
        return cell
    }
}

extension UsersCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32) / 3
        return CGSize(width: width, height: 192)
    }
}
