//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 08.09.2024.
//

import UIKit

protocol CartPresenterProtocol: AnyObject {
    var cartNfts: [CartNft] { get  set }
    var servicesAssembly: ServicesAssembly { get }
    
    func loadData()
    func didTapDeleteButton(image: UIImage, id: String)
    func calculateTotalPrice() -> Float
    func removePositionFromCart(id: String)
    func handlePaymentButtonTapped()
    func sortByPrice()
    func sortByRating()
    func sortByName()
}

final class CartPresenter: CartPresenterProtocol {
    var cartNfts = [CartNft]()
    let servicesAssembly: ServicesAssembly
    
    private weak var view: CartViewControllerProtocol?
    private let orderService: OrderService
    
    init(view: CartViewControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
        self.orderService = servicesAssembly.orderService
    }
    
    func loadData() {
        getCartNfts()
    }
    
    func didTapDeleteButton(image: UIImage, id: String) {
        let deleteViewController = DeleteViewController()
        let deletePresenter = DeletePresenter(view: deleteViewController, servicesAssembly: servicesAssembly, image: image, id: id)
        deletePresenter.removePositionClosure = self.getRemovePositionClosure()
        deleteViewController.presenter = deletePresenter
        deleteViewController.modalPresentationStyle = .overFullScreen
        view?.navigateToDeleteViewController(viewController: deleteViewController)
    }
    
    func calculateTotalPrice() -> Float {
        let price: Float = cartNfts.reduce(0) { $0 + $1.price }
        let roundedPrice = round(price * 10000) / 10000
        return roundedPrice
    }
    
    func removePositionFromCart(id: String) {
        view?.showLoading()
        servicesAssembly.orderService.deleteNftRequest(withId: id, from: cartNfts) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let updateData):
                self.cartNfts = updateData
                view?.updateView()
                view?.hideLoading()
                view?.checkArrayAndShowPlaceholder()
                
                print("Позиция \(id) удалена")
            case .failure(_):
                view?.hideLoading()
                view?.showFailedDeleteFromCartAlert()
            }
        }
    }
    
    func getRemovePositionClosure() -> (String) -> Void {
        return { [weak self] id in
            self?.removePositionFromCart(id: id)
        }
    }
    
    func getClearCartClosure() -> Void {
        self.cartNfts = []
        self.view?.checkArrayAndShowPlaceholder()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view?.tableView.reloadData()
        }
    }
    
    func handlePaymentButtonTapped() {
        let paymentViewController = PaymentViewController()
        let paymentPresenter = PaymentPresenter(view: paymentViewController, servicesAssembly: self.servicesAssembly)
        paymentViewController.title = Localizable.paymentTitle
        paymentViewController.hidesBottomBarWhenPushed = true
        paymentViewController.presenter = paymentPresenter
        paymentViewController.presenter?.clearCartClosure = getClearCartClosure
        self.view?.navigateToPaymentViewController(viewController: paymentViewController)
    }
    
    func sortByPrice() {
        cartNfts.sort { $0.price < $1.price }
        view?.tableView.reloadData()
    }
    
    func sortByRating() {
        cartNfts.sort { $0.rating < $1.rating }
        view?.tableView.reloadData()
    }
    
    func sortByName() {
        cartNfts.sort { $0.name < $1.name }
        view?.tableView.reloadData()
    }
    
    private func getCartNfts() {
        orderService.fetchOrderNfts { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let nftIds):
                guard !nftIds.isEmpty else {
                    self.view?.hideLoading()
                    self.view?.checkArrayAndShowPlaceholder()
                    return
                }
                
                self.processNftIds(nftIds)
                
            case .failure(let error):
                print("Error in receiving NFT details:", error)
                
                self.view?.hideLoading()
                self.view?.showFailedLoadingCartAlert()
            }
        }
    }
    
    private func processNftIds(_ nftIds: [String]) {
        var remainingRequests = nftIds.count
        
        for nftId in nftIds {
            self.orderService.fetchNftDetails(for: nftId) { [weak self] detailResult in
                guard let self else { return }
                
                switch detailResult {
                case .success(let nftDetail):
                    self.orderService.convertToCartNft(from: nftDetail) { [weak self] cartNft in
                        guard let self else { return }
                        
                        if let cartNft = cartNft {
                            self.cartNfts.append(cartNft)
                        } else {
                            print("Error when converting NFT")
                        }
                        
                        remainingRequests -= 1
                        if remainingRequests == 0 {
                            self.view?.hideLoading()
                            self.view?.updateView()
                        }
                        
                    }
                case .failure(let error):
                    print("Error in receiving NFT details:", error)
                    
                    remainingRequests -= 1
                    if remainingRequests == 0 {
                        self.view?.hideLoading()
                        self.view?.showFailedLoadingCartAlert()
                    }
                }
            }
        }
    }
}
