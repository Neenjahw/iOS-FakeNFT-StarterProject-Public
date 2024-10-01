//
//  MyFavoritesNFTViewController.swift
//  FakeNFT
//
//  Created by gimon on 22.09.2024.
//

import UIKit

protocol MyFavoritesNFTViewControllerProtocol: AnyObject, LoadingView {
    func showMyNFT(isEmpty: Bool)
    func delete(likeId: String)
    func showErrorAlert(message: String)
}

final class MyFavoritesNFTViewController: UIViewController, MyFavoritesNFTViewControllerProtocol {
    //MARK: - Visual Components
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private lazy var emptyLabel: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .bodyBold
        view.text = LocalizedText.emptyFavoritesNFT
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(font: .bodyBold)
        let image = UIImage(
            systemName: "chevron.left",
            withConfiguration: configuration
        )
        let view = UIButton.systemButton(
            with: image ?? UIImage(),
            target: self,
            action: #selector(clickBackButton)
        )
        view.tintColor = .closeButton
        return view
    }()
    
    private lazy var favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsSelection = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    //MARK: - Private Properties
    private let cellIdentifier = "MyFavoritesNFTViewCellIdentifier"
    private var myFavoritesNFTPresenter: MyFavoritesNFTPresenterProtocol
    
    init(myFavoritesNFTPresenter: MyFavoritesNFTPresenterProtocol) {
        self.myFavoritesNFTPresenter = myFavoritesNFTPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        navigationItem.titleView?.backgroundColor = .backgroundColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        
        [
            favoritesCollectionView,
            emptyLabel,
            activityIndicator
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        favoritesCollectionView.register(
            MyFavoritesNFTViewCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )
        
        activityIndicator.constraintCenters(to: view)
        addConstraintFavoritesCollectionView()
        emptyLabel.constraintCenters(to: view)
        self.showLoading()
        myFavoritesNFTPresenter.loadAllMyFavoritesNFT()
    }
    
    // MARK: - Public Methods
    func showMyNFT(isEmpty: Bool) {
        self.hideLoading()
        
        if isEmpty {
            emptyLabel.isHidden = false
        } else {
            favoritesCollectionView.isHidden = false
            navigationItem.title = LocalizedText.myFavoritesNFTNavbarTitle
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.bodyBold
            ]
            favoritesCollectionView.reloadData()
        }
    }
    
    func delete(likeId: String) {
        favoritesCollectionView.isHidden = true
        navigationItem.title?.removeAll()
        showLoading()
        myFavoritesNFTPresenter.deleteNFT(likeId: likeId)
    }
    
    // MARK: - Private Methods
    private func addConstraintFavoritesCollectionView() {
        NSLayoutConstraint.activate(
            [
                favoritesCollectionView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: ConstantsConstraint.favoritesCollectionViewTopOffset
                ),
                favoritesCollectionView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                ),
                favoritesCollectionView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor,
                    constant: -ConstantsConstraint.defaultOffset
                ),
                favoritesCollectionView.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor
                )
            ]
        )
    }
    
    @objc private func clickBackButton() {
        dismiss(animated: true)
    }
}

//MARK: - ConstantsConstraint
extension MyFavoritesNFTViewController {
    private enum ConstantsConstraint {
        static let favoritesCollectionViewTopOffset: CGFloat = 20
        static let defaultOffset: CGFloat = 16
        static let minimumLineSpacingForSectionAt: CGFloat = 20
        static let minimumInteritemSpacingForSectionAt: CGFloat = 7
        static let cellWidth: CGFloat = 168
        static let cellHeight: CGFloat = 80
    }
}

//MARK: - UICollectionViewDelegate
extension MyFavoritesNFTViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDataSource
extension MyFavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myFavoritesNFTPresenter.countMyFavoritesNFT()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoritesCollectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? MyFavoritesNFTViewCell else {
            return UICollectionViewCell()
        }
        let nft = myFavoritesNFTPresenter.getFavoritesNFT(indexArray: indexPath.row)
        cell.configCell(
            image: nft.images.first,
            name: nft.name,
            idNFT: nft.id,
            priceNFT: nft.price,
            star: nft.rating,
            delegate: self
        )
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MyFavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: ConstantsConstraint.cellWidth,
            height: ConstantsConstraint.cellHeight
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ConstantsConstraint.minimumInteritemSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ConstantsConstraint.minimumLineSpacingForSectionAt
    }
}
