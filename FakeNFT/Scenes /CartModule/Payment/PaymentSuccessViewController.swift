//
//  PaymentSuccessViewController.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 21.09.2024.
//

import UIKit

final class PaymentSuccessViewController: UIViewController {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paymentSuccessImage")
        imageView.backgroundColor = UIColor.whiteObjectColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = Localizable.successMessage
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.darkObjectColor
        messageLabel.font = UIFont.headline3
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    private lazy var returnInCatalogButton: UIButton = {
        let returnInCatalogButton = UIButton(type: .system)
        returnInCatalogButton.setTitle(Localizable.successButton, for: .normal)
        returnInCatalogButton.tintColor = UIColor.whiteObjectColor
        returnInCatalogButton.titleLabel?.font = UIFont.bodyBold
        returnInCatalogButton.addTarget(self, action: #selector(returnInCatalogButtonTapped), for: .touchUpInside)
        returnInCatalogButton.layer.cornerRadius = 16
        returnInCatalogButton.backgroundColor = UIColor.darkObjectColor
        returnInCatalogButton.translatesAutoresizingMaskIntoConstraints = false
        return returnInCatalogButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.whiteObjectColor
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        view.addSubview(returnInCatalogButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 49),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            returnInCatalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnInCatalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnInCatalogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnInCatalogButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func returnInCatalogButtonTapped() {
        self.dismiss(animated: true) {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
               let tabBarController = window.rootViewController as? TabBarController,
               let navigationController = tabBarController.selectedViewController as? UINavigationController {
                
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
}
