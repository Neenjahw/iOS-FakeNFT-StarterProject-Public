//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by gimon on 18.09.2024.
//

import UIKit

protocol MyNFTViewControllerProtocol: AnyObject, LoadingView {
    func showMyNFT(isEmpty: Bool)
    func reloadTableMyNFT()
    func showErrorAlert(message: String)
}

final class MyNFTViewController: UIViewController, MyNFTViewControllerProtocol {
    //MARK: - Visual Components
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private lazy var emptyLabel: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .bodyBold
        view.text = LocalizedText.emptyNFT
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()
    
    private lazy var tableMyNFT: UITableView = {
        let view = UITableView()
        view.allowsSelection = false
        view.separatorStyle = .none
        view.isHidden = true
        view.backgroundColor = .backgroundColor
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
    
    private lazy var sortButton: UIButton = {
        let image = UIImage(named: "sort")
        let view = UIButton.systemButton(
            with: image ?? UIImage(),
            target: self,
            action: #selector(clickSortButton)
        )
        view.tintColor = .closeButton
        return view
    }()
    
    //MARK: - Private Property
    private let cellReuseIdentifier = "MyNFTTableCellIdentifier"
    private var myNFTPresenter: MyNFTPresenterProtocol
    
    init(myNFTPresenter: MyNFTPresenterProtocol) {
        self.myNFTPresenter = myNFTPresenter
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
        
        tableMyNFT.delegate = self
        tableMyNFT.dataSource = self
        
        [
            tableMyNFT,
            emptyLabel,
            activityIndicator
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableMyNFT.register(
            MyNFTTableViewCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        
        activityIndicator.constraintCenters(to: view)
        addConstraintTableMyNFT()
        addConstraintEmptyLabel()
        self.showLoading()
        myNFTPresenter.loadAllMyNFT()
    }
    
    func showMyNFT(isEmpty: Bool) {
        self.hideLoading()
        
        if isEmpty {
            emptyLabel.isHidden = false
        } else {
            tableMyNFT.isHidden = false
            navigationItem.title = LocalizedText.myNFTNavbarTitle
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.bodyBold
            ]
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
            tableMyNFT.reloadData()
        }
    }
    
    func reloadTableMyNFT() {
        self.hideLoading()
        tableMyNFT.reloadData()
    }
    
    // MARK: - Private Methods
    private func addConstraintTableMyNFT() {
        NSLayoutConstraint.activate(
            [
                tableMyNFT.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: ConstantsConstraint.tableMyNFTTopOffset
                ),
                tableMyNFT.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor
                ),
                tableMyNFT.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor
                ),
                tableMyNFT.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor
                )
            ]
        )
    }
    
    private func addConstraintEmptyLabel() {
        NSLayoutConstraint.activate(
            [
                emptyLabel.centerXAnchor.constraint(
                    equalTo: view.centerXAnchor
                ),
                emptyLabel.centerYAnchor.constraint(
                    equalTo: view.centerYAnchor
                )
            ]
        )
    }
    
    @objc private func clickBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func clickSortButton() {
        present(getSortNFTAlert(), animated: true)
    }
    
}

//MARK: - ConstantsConstraint
extension MyNFTViewController {
    private enum ConstantsConstraint {
        static let tableMyNFTTopOffset: CGFloat = 20
        static let heightCell: CGFloat = 140
    }
}

//MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstantsConstraint.heightCell
    }
}

//MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myNFTPresenter.countMyNFT()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? MyNFTTableViewCell else {
            return UITableViewCell()
        }
        let nft = myNFTPresenter.getNFT(indexArray: indexPath.row)
        cell.configCell(
            image: nft.images.first,
            name: nft.name,
            author: nft.author,
            priceNFT: nft.price,
            star: nft.rating
        )
        return cell
    }
}

//MARK: - UIAlertController
extension MyNFTViewController {
    private func getSortNFTAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: nil,
            message: LocalizedText.sortAlertTitle,
            preferredStyle: .actionSheet)
        
        let sortPrise = UIAlertAction(
            title: LocalizedText.sortAlertPrice,
            style: .default
        ) { [weak self] _ in
            self?.showLoading()
            self?.myNFTPresenter.sortMyNft(variant: .price)
        }
        
        let sortRating = UIAlertAction(
            title: LocalizedText.sortAlertRating,
            style: .default
        ) { [weak self] _ in
            self?.showLoading()
            self?.myNFTPresenter.sortMyNft(variant: .rating)
        }
        
        let sortName = UIAlertAction(
            title: LocalizedText.sortAlertName,
            style: .default
        ) { [weak self] _ in
            self?.showLoading()
            self?.myNFTPresenter.sortMyNft(variant: .name)
        }
        
        let cancelAction = UIAlertAction(
            title: LocalizedText.sortAlertClose,
            style: .cancel
        )
        
        [sortPrise,
         sortRating,
         sortName,
         cancelAction].forEach { action in
            alert.addAction(action)
        }
        return alert
    }
}
