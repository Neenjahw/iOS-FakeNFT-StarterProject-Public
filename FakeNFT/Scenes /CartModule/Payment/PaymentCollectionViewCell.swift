//
//  PaymentCollectionViewCell.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 13.09.2024.
//

import UIKit

final class PaymentCollectionViewCell: UICollectionViewCell {
    static let identifier = "PaymentCollectionViewCell"
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.blackLight
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var currencyImageView: UIImageView = {
        let currencyImageView = UIImageView()
        currencyImageView.translatesAutoresizingMaskIntoConstraints = false
        return currencyImageView
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let currencyNameLabel = UILabel()
        currencyNameLabel.textAlignment = .left
        currencyNameLabel.font = UIFont.caption2
        currencyNameLabel.textColor = UIColor.darkObjectColor
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return currencyNameLabel
    }()
    
    private lazy var currencySymbolLabel: UILabel = {
        let currencySymbolLabel = UILabel()
        currencySymbolLabel.textAlignment = .left
        currencySymbolLabel.font = UIFont.caption2
        currencySymbolLabel.textColor = UIColor.textGreen
        currencySymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        return currencySymbolLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        contentView.addSubview(currencyNameLabel)
        contentView.addSubview(currencySymbolLabel)
        containerView.addSubview(currencyImageView)
        layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.widthAnchor.constraint(equalToConstant: 36),
            containerView.heightAnchor.constraint(equalToConstant: 36),
            
            currencyImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2.5),
            currencyImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2.5),
            currencyImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2.5),
            currencyImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2.5),
            
            currencyNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            currencyNameLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 4),
            
            currencySymbolLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 4),
            currencySymbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(currencyName: String, currencySymbol: String, image: UIImage) {
        currencyNameLabel.text = currencyName
        currencySymbolLabel.text = currencySymbol
        currencyImageView.image = image
    }
}
