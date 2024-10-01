//
//  MyNFTTableViewCell.swift
//  FakeNFT
//
//  Created by gimon on 17.09.2024.
//

import UIKit
import Kingfisher

final class MyNFTTableViewCell: UITableViewCell {
    //MARK: - Visual Components
    private lazy var imageNFT: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nameNFT: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .bodyBold
        return view
    }()
    
    private lazy var labelFrom: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .caption1
        view.text = LocalizedText.cellFrom
        return view
    }()
    
    private lazy var authorNFT: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .caption2
        return view
    }()
    
    private lazy var tittlePrice: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .caption2
        view.text = LocalizedText.cellPrice
        return view
    }()
    
    private lazy var price: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .bodyBold
        return view
    }()
    
    private lazy var ratingStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 2
        return view
    }()
    
    private lazy var authorStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .bottom
        view.spacing = 4
        return view
    }()
    
    private lazy var infoStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 4
        return view
    }()
    
    private lazy var priceStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 2
        return view
    }()
    
    // MARK: - Private Property
    private var countStar = 0
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .backgroundColor
        
        [
            imageNFT,
            nameNFT,
            labelFrom,
            authorNFT,
            tittlePrice,
            price,
            ratingStack,
            authorStack,
            infoStack,
            priceStack
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            labelFrom,
            authorNFT
        ].forEach{
            authorStack.addArrangedSubview($0)
        }
        
        [
            nameNFT,
            ratingStack,
            authorStack
        ].forEach{
            infoStack.addArrangedSubview($0)
        }
        
        [
            tittlePrice,
            price
        ].forEach{
            priceStack.addArrangedSubview($0)
        }
        
        [
            imageNFT,
            infoStack,
            priceStack
        ].forEach{
            contentView.addSubview($0)
        }
        
        addConstraintImageNFT()
        addConstraintInfoStack()
        addConstraintPriceStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configCell(
        image: URL?,
        name: String,
        author: String,
        priceNFT: Float,
        star: Int
    ) {
        imageNFT.kf.setImage(with: image)
        nameNFT.text = name
        authorNFT.text = author
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.currencyCode = "ETH"
        price.text = formatter.string(from: NSNumber(value: priceNFT)) ?? "0"
        countStar = star
        
        addStarInRating()
    }
    
    override func prepareForReuse() {
        ratingStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    // MARK: - Private Methods
    private func addConstraintImageNFT() {
        NSLayoutConstraint.activate(
            [
                imageNFT.heightAnchor.constraint(
                    equalToConstant: ConstantsConstraint.imageNFTSize
                ),
                imageNFT.widthAnchor.constraint(
                    equalToConstant: ConstantsConstraint.imageNFTSize
                ),
                imageNFT.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                ),
                imageNFT.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: ConstantsConstraint.defaultOffset
                ),
                imageNFT.bottomAnchor.constraint(
                    equalTo: bottomAnchor,
                    constant: -ConstantsConstraint.defaultOffset
                )
            ]
        )
    }
    
    private func addConstraintInfoStack() {
        NSLayoutConstraint.activate(
            [
                infoStack.centerYAnchor.constraint(
                    equalTo: imageNFT.centerYAnchor
                ),
                infoStack.leadingAnchor.constraint(
                    equalTo: imageNFT.trailingAnchor,
                    constant: ConstantsConstraint.infoStackLeftOffset
                ),
                infoStack.widthAnchor.constraint(
                    equalToConstant: ConstantsConstraint.infoStackWidth
                )
            ]
        )
    }
    
    private func addConstraintPriceStack() {
        NSLayoutConstraint.activate(
            [
                priceStack.centerYAnchor.constraint(
                    equalTo: imageNFT.centerYAnchor
                ),
                priceStack.leadingAnchor.constraint(
                    equalTo: imageNFT.trailingAnchor,
                    constant: ConstantsConstraint.priceStackLeftOffset
                )
            ]
        )
    }
    
    private func addStarInRating() {
        for i in 0..<5 {
            let image = UIImage(
                systemName: "star.fill"
            )?.withRenderingMode(.alwaysTemplate)
            let imageStar = UIImageView(image: image)
            imageStar.tintColor = countStar > i ? .yellowStar : .segmentInactive
            imageStar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                [
                    imageStar.heightAnchor.constraint(
                        equalToConstant: ConstantsConstraint.imageStarSize
                    ),
                    imageStar.widthAnchor.constraint(
                        equalToConstant: ConstantsConstraint.imageStarSize
                    )
                ]
            )
            ratingStack.addArrangedSubview(imageStar)
        }
    }
}

extension MyNFTTableViewCell {
    private enum ConstantsConstraint {
        static let defaultOffset: CGFloat = 16
        static let imageNFTSize: CGFloat = 108
        static let imageStarSize: CGFloat = 12
        static let infoStackLeftOffset: CGFloat = 20
        static let priceStackLeftOffset: CGFloat = 137
        static let infoStackWidth: CGFloat = 78
    }
}
