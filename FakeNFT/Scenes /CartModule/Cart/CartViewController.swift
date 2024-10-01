//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 08.09.2024.
//

import UIKit

protocol CartViewControllerProtocol: AnyObject {
    var tableView: UITableView { get }
    
    func updateView()
    func navigateToDeleteViewController(viewController: UIViewController)
    func navigateToPaymentViewController(viewController: UIViewController)
    func showLoading()
    func hideLoading()
    func showFailedLoadingCartAlert()
    func showFailedDeleteFromCartAlert()
    func checkArrayAndShowPlaceholder()
}

final class CartViewController: UIViewController, CartViewControllerProtocol {
    var presenter: CartPresenterProtocol?
    
    private let currencySymbol = "ETH"
    private let nftLabel = "NFT"
    private var alertPresenter: AlertPresenter?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.whiteObjectColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var paymentButton: UIButton = {
        let paymentButton = UIButton(type: .system)
        paymentButton.setTitle(Localizable.cartPaymentButton, for: .normal)
        paymentButton.tintColor = UIColor.whiteObjectColor
        paymentButton.titleLabel?.font = UIFont.bodyBold
        paymentButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
        paymentButton.layer.cornerRadius = 16
        paymentButton.backgroundColor = UIColor.darkObjectColor
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        return paymentButton
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let nftCountLabel = UILabel()
        if let presenter = presenter {
            nftCountLabel.text = "\(presenter.cartNfts.count) \(nftLabel)"
        } else {
            nftCountLabel.text = "0 \(nftLabel)"
        }
        nftCountLabel.textColor = UIColor.darkObjectColor
        nftCountLabel.font = UIFont.caption1
        nftCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return nftCountLabel
    }()
    
    private lazy var sumLabel: UILabel = {
        let sumLabel = UILabel()
        let sum = presenter?.calculateTotalPrice() ?? Float()
        sumLabel.text = "\(sum) \(currencySymbol)"
        sumLabel.textColor = UIColor.textGreen
        sumLabel.font = UIFont.bodyBold
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        return sumLabel
    }()
    
    private lazy var paymentAreaView: UIView = {
        let paymentAreaView = UIView()
        paymentAreaView.layer.cornerRadius = 12
        paymentAreaView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        paymentAreaView.layer.masksToBounds = true
        paymentAreaView.backgroundColor = UIColor.paymentAreaColor
        paymentAreaView.translatesAutoresizingMaskIntoConstraints = false
        return paymentAreaView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = Localizable.placeholderTextLabel
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = UIColor.darkObjectColor
        placeholderLabel.font = UIFont.bodyBold
        placeholderLabel.frame = self.view.bounds
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.isHidden = true
        return placeholderLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.cartNfts = []
        loadData()
    }

    func updateView() {
        let updateSum = presenter?.calculateTotalPrice() ?? Float()
        let updateCountNft = presenter?.cartNfts.count ?? Int()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.nftCountLabel.text = "\(updateCountNft) NFT"
            self.sumLabel.text = "\(updateSum) ETH"
            self.tableView.reloadData()
        }
    }
    
    func navigateToDeleteViewController(viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func navigateToPaymentViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showFailedLoadingCartAlert() {
        if let alertPresenter = self.alertPresenter {
            let cancelAction = alertPresenter.createAction(title: Localizable.alertCancelButton, style: .cancel) { [weak self] _ in
                guard let self else { return }
                self.checkArrayAndShowPlaceholder()
            }
            let retryAction = alertPresenter.createAction(title: Localizable.alertRepeatButton, style: .default) { [weak self] _ in
                guard let self else { return }
                self.loadData()
            }
            
            alertPresenter.showAlert(title: Localizable.alertCartErrorMessage, actions: [cancelAction, retryAction])
        }
    }
    
    func showFailedDeleteFromCartAlert() {
        if let alertPresenter = self.alertPresenter {
            let okAction = alertPresenter.createAction(title: Localizable.alertOkayButton, style: .default) { _ in }
            
            alertPresenter.showAlert(title: Localizable.alertDeleteErrorMessage, actions: [okAction])
        }
    }
    
    func checkArrayAndShowPlaceholder() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if presenter?.cartNfts.isEmpty ?? true {
                placeholderLabel.isHidden = false
                tableView.isHidden = true
                paymentAreaView.isHidden = true
            }
            
            tableView.reloadData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.whiteObjectColor
        view.addSubview(tableView)
        view.addSubview(paymentAreaView)
        view.addSubview(activityIndicator)
        view.addSubview(placeholderLabel)
        paymentAreaView.addSubview(paymentButton)
        paymentAreaView.addSubview(nftCountLabel)
        paymentAreaView.addSubview(sumLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            paymentAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentAreaView.heightAnchor.constraint(equalToConstant: 76),
            
            paymentButton.trailingAnchor.constraint(equalTo: paymentAreaView.trailingAnchor, constant: -16),
            paymentButton.bottomAnchor.constraint(equalTo: paymentAreaView.bottomAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 44),
            
            nftCountLabel.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            nftCountLabel.bottomAnchor.constraint(equalTo: sumLabel.topAnchor, constant: -2),
            
            sumLabel.leadingAnchor.constraint(equalTo: paymentAreaView.leadingAnchor, constant: 16),
            sumLabel.trailingAnchor.constraint(equalTo: paymentButton.leadingAnchor, constant: -24),
            sumLabel.bottomAnchor.constraint(equalTo: paymentAreaView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupNavigationBar() {
        let iconImage = UIImage(named: "lineHorizontal")
        let barButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(sortButtonTapped))
        barButtonItem.tintColor = UIColor.darkObjectColor
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: Localizable.sortingTitle, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Localizable.sortingPrice, style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.presenter?.sortByPrice()
        }))
        actionSheet.addAction(UIAlertAction(title: Localizable.sortingRating, style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.presenter?.sortByRating()
        }))
        actionSheet.addAction(UIAlertAction(title: Localizable.sortingName, style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.presenter?.sortByName()
        }))
        
        actionSheet.addAction(UIAlertAction(title: Localizable.sortingCancelButton, style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    @objc private func sortButtonTapped() {
        showActionSheet()
    }
    
    @objc private func paymentButtonTapped() {
        presenter?.handlePaymentButtonTapped()
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.cartNfts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        if let presenter = presenter {
            guard indexPath.row >= 0 && indexPath.row < presenter.cartNfts.count else {
                return UITableViewCell()
            }
            
            let nft = presenter.cartNfts[indexPath.row]
            
            cell.configure(image: nft.image, 
                           name: nft.name,
                           rating: nft.rating,
                           price: "\(nft.price) \(currencySymbol)")
            
            cell.onDeleteButtonTapped = { [weak self] in
                guard self != nil else { return }
                presenter.didTapDeleteButton(image: nft.image, id: nft.id)
            }
        }

        cell.backgroundColor = UIColor.whiteObjectColor
        cell.selectionStyle = .none
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController {
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    private func loadData() {
        showLoading()
        presenter?.loadData()
    }
}


