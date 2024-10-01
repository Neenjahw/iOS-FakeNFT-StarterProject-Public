import Kingfisher
import ProgressHUD
import UIKit

final class UserCardViewController: UIViewController {
    
    private var userNFTs: [String] = []
    private var userWebsite = ""
    
    private lazy var profileImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.tintColor = .greyUniversal
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        return label
    }()
    
    private lazy var descriptionTextView = {
        let textView = UITextView()
        textView.font = UIFont.caption2
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 18)
        return textView
    }()
    
    private lazy var websiteButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(NSLocalizedString("Statistics.userCard.website", comment: "Button to go to user's website"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.caption1
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapWebsiteButton), for: .touchUpInside)
        button.isEnabled = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    private lazy var collectionButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapCollectionButton), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    private lazy var nftCollectionLabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        return label
    }()
    
    private lazy var nftCollectionImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .black
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        setupUI()
    }
    
    func configure(for user: User) {
        profileImageView.kf.setImage(with: URL(string: user.avatar), placeholder: UIImage(systemName: "person.crop.circle.fill"))
        nameLabel.text = user.name
        descriptionTextView.text = user.description
        let collectionTitle = NSLocalizedString("Statistics.Collection.title", comment: "Title for NFT collection")
        nftCollectionLabel.text = String(format: "%@ (%d)", collectionTitle, user.nfts.count)
        userNFTs = user.nfts
        userWebsite = user.website
        
        websiteButton.isEnabled = !userWebsite.isEmpty
    }
    
    private func setupUI() {
        setupNaviBar()
        setupConstraints()
    }
    
    private func setupNaviBar() {
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
        [profileImageView, nameLabel, descriptionTextView, websiteButton, collectionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [nftCollectionLabel, nftCollectionImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            collectionButton.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            descriptionTextView.heightAnchor.constraint(equalToConstant: 72),
            descriptionTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            websiteButton.heightAnchor.constraint(equalToConstant: 40),
            websiteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 28),
            websiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionButton.heightAnchor.constraint(equalToConstant: 54),
            collectionButton.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            collectionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            nftCollectionImageView.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
            nftCollectionImageView.trailingAnchor.constraint(equalTo: collectionButton.trailingAnchor, constant: -16),
            
            nftCollectionLabel.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
            nftCollectionLabel.leadingAnchor.constraint(equalTo: collectionButton.leadingAnchor, constant: 16)
        ])
    }
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCollectionButton() {
        let viewController = UsersCollectionViewController(userNFTs: userNFTs)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc
    private func didTapWebsiteButton() {
        let viewController = UserWebViewController()
        viewController.loadWebsite(userWebsite)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

