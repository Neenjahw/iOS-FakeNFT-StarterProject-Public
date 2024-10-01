//
//  DeleteViewController.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 09.09.2024.
//

import UIKit

protocol DeleteViewProtocol: AnyObject {}

final class DeleteViewController: UIViewController, DeleteViewProtocol {
    var presenter: DeletePresenterProtocol?
    
    lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.image = presenter?.image
        nftImageView.layer.cornerRadius = 12
        nftImageView.layer.masksToBounds = true
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        return nftImageView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = Localizable.deleteWarning
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.font = UIFont.caption2
        messageLabel.textColor = UIColor.darkObjectColor
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle(Localizable.deleteDeleteButton, for: .normal)
        deleteButton.tintColor = UIColor.textRed
        deleteButton.titleLabel?.font = UIFont.bodyRegular
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.layer.cornerRadius = 12
        deleteButton.backgroundColor = UIColor.darkObjectColor
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(Localizable.deleteCancelButton, for: .normal)
        cancelButton.tintColor = UIColor.whiteObjectColor
        cancelButton.titleLabel?.font = UIFont.bodyRegular
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 12
        cancelButton.backgroundColor = UIColor.darkObjectColor
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear
        view.insertSubview(blurEffectView, at: 0)
        view.addSubview(containerView)
        containerView.addSubview(nftImageView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 262),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 220),
            
            nftImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 77),
            nftImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -77),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            messageLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 41),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -41),
            
            deleteButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
        ])
    }
    
    @objc private func deleteButtonTapped() {
        presenter?.handleDeleteButtonTapped()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

