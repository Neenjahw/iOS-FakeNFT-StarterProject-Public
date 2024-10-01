//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 13.09.2024.
//

import UIKit

protocol PaymentPresenterProtocol {
    var cryptocurrencies: [Cryptocurrency] { get }
    var selectedCryprocurrncy: Int? { get set }
    var clearCartClosure: (() -> Void)? { get set }
    
    func getListCryptocurrencies()
    func handleAgreementButtonTapped()
    func handlePayButtonTapped()
}

final class PaymentPresenter: PaymentPresenterProtocol {
    var cryptocurrencies: [Cryptocurrency] = []
    var selectedCryprocurrncy: Int?
    var clearCartClosure: (() -> Void)?
    weak var view: PaymentViewControllerProtocol?
    
    private let servicesAssembly: ServicesAssembly
    
    init(view: PaymentViewControllerProtocol, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.servicesAssembly = servicesAssembly
    }
    
    func getListCryptocurrencies() {  
        servicesAssembly.paymentService.fetchCryptocurrcencies { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let cryptocurrencies):
                guard !cryptocurrencies.isEmpty else {
                    self.view?.hideLoading()
                    return
                }
                
                self.cryptocurrencies = cryptocurrencies
                view?.hideLoading()
                view?.updateData()
            case .failure(let error):
                print("Error in obtaining information about cryptocurrencies:", error)
                
                self.view?.hideLoading()
                self.view?.showFailedLoadingPaymentMethodsAlert()
            }
        }
    }
    
    func handleAgreementButtonTapped() {
        let agreementViewController = AgreementViewController()
        agreementViewController.hidesBottomBarWhenPushed = true
        self.view?.navigateToAgreementViewController(viewController: agreementViewController)
    }
    
    func handlePayButtonTapped() {
        guard let indexCryptocurrency = self.selectedCryprocurrncy else {
            view?.showCurrencySelectionAlert()
            return
        }
        
        view?.showLoading()
        
        servicesAssembly.paymentService.payForOrder(cryptocurrencyIndex: indexCryptocurrency) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    if success {
                        self.cleaningCart()
                        self.view?.hideLoading()
                        self.showPaymentSuccessViewController()
                    } else {
                        self.view?.hideLoading()
                        self.view?.showFailedPaymentAlert()
                        print("Failure. The server has been rejected.")
                    }
                case .failure(let error):
                    self.view?.hideLoading()
                    self.view?.showFailedPaymentAlert()
                    print("Request error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showPaymentSuccessViewController() {
        let paymentSuccessViewController = PaymentSuccessViewController()
        paymentSuccessViewController.modalPresentationStyle = .overFullScreen
        view?.navigateToPaymentSuccessViewController(viewController: paymentSuccessViewController)
    }
    
    private func cleaningCart() {
        servicesAssembly.orderService.cleaningCart { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.clearCartClosure?()
            case.failure(let error):
                print("Could not empty the cart: \(error.localizedDescription)")
            }
        }
    }
}
