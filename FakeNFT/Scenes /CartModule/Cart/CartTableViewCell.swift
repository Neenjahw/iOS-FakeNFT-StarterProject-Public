//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 08.09.2024.
//

import UIKit

final class CartTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
    var onDeleteButtonTapped: (() -> Void)?
    
    private var nftRating: Int = 0
    
    lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = 12
        nftImageView.layer.masksToBounds = true
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        return nftImageView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteObjectColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.bodyBold
        nameLabel.textColor = UIColor.darkObjectColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let ratingStackView = UIStackView()
        ratingStackView.axis = .horizontal
        ratingStackView.distribution = .fill
        ratingStackView.alignment = .center
        ratingStackView.spacing = 2
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        return ratingStackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = Localizable.nftCellPrice
        priceLabel.font = UIFont.caption2
        priceLabel.textColor = UIColor.darkObjectColor
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let priceValueLabel = UILabel()
        priceValueLabel.font = UIFont.bodyBold
        priceValueLabel.textColor = UIColor.darkObjectColor
        priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceValueLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .custom)
        if let image = UIImage(named: "deleteCartIcon")?.withRenderingMode(.alwaysTemplate) {
                deleteButton.setImage(image, for: .normal)
            }
        deleteButton.tintColor = UIColor.darkObjectColor
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, name: String, rating: Int, price: String) {
        nftImageView.image = image
        nameLabel.text = name
        nftRating = rating
        priceValueLabel.text = price
        
        setupRatingStars()
    }
    
    private func setupCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(nftImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(ratingStackView)
        containerView.addSubview(priceLabel)
        containerView.addSubview(priceValueLabel)
        containerView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nftImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            ratingStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            priceLabel.bottomAnchor.constraint(equalTo: priceValueLabel.topAnchor, constant: -2),
            
            priceValueLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            priceValueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            
            deleteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func setupRatingStars() {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<5 {
            let ratingImageView = UIImageView()
            
            if i < nftRating {
                ratingImageView.image = UIImage(named: "ratingIcon")
            } else {
                ratingImageView.image = UIImage(named: "ratingIconVoid")
            }
            
            ratingImageView.contentMode = .scaleAspectFit
            ratingImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            ratingImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            ratingStackView.addArrangedSubview(ratingImageView)
        }
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteButtonTapped?()
    }
}
