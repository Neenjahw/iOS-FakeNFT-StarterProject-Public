//
//  MyFavoritesNFTViewCell.swift
//  FakeNFT
//
//  Created by gimon on 22.09.2024.
//

import UIKit

final class MyFavoritesNFTViewCell: UICollectionViewCell {
    //MARK: - Visual Components
    private lazy var imageNFT: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var heartButton: UIButton = {
        guard let image = UIImage(systemName: "heart.fill") else {
            assertionFailure("error create image heartButton")
            return UIButton()
        }
        let view = UIButton.systemButton(
            with: image,
            target: self,
            action: #selector(clickHeartButton)
        )
        view.tintColor = .heartRed
        return view
    }()
    
    private lazy var nameNFT: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .bodyBold
        return view
    }()
    
    private lazy var price: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .caption1
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
    
    private lazy var infoStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    private lazy var nameRatingStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 4
        return view
    }()
    
    //MARK: - Private Property
    private var idNFT: String?
    private weak var delegate: MyFavoritesNFTViewControllerProtocol?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .backgroundColor
        
        [
            imageNFT,
            heartButton,
            nameNFT,
            price,
            ratingStack,
            nameRatingStack,
            infoStack
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            nameNFT,
            ratingStack
        ].forEach{
            nameRatingStack.addArrangedSubview($0)
        }
        
        [
            nameRatingStack,
            price
        ].forEach{
            infoStack.addArrangedSubview($0)
        }
        
        [
            imageNFT,
            heartButton,
            infoStack
        ].forEach{
            contentView.addSubview($0)
        }
        
        addConstraintImageNFT()
        addConstraintInfoStack()
        addConstraintHeartButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configCell(
        image: URL?,
        name: String,
        idNFT: String,
        priceNFT: Float,
        star: Int,
        delegate: MyFavoritesNFTViewControllerProtocol
    ) {
        imageNFT.kf.setImage(with: image)
        nameNFT.text = name
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.currencyCode = LocalizedText.myFavoritesNftETH
        price.text = formatter.string(from: NSNumber(value: priceNFT)) ?? "0"
        self.idNFT = idNFT
        self.delegate = delegate
        addStarInRating(countStar: star)
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
                    equalTo: leadingAnchor
                ),
                imageNFT.topAnchor.constraint(
                    equalTo: topAnchor
                ),
                imageNFT.bottomAnchor.constraint(
                    equalTo: bottomAnchor
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
    
    private func addConstraintHeartButton() {
        NSLayoutConstraint.activate(
            [
                heartButton.topAnchor.constraint(
                    equalTo: imageNFT.topAnchor
                ),
                heartButton.trailingAnchor.constraint(
                    equalTo: imageNFT.trailingAnchor
                ),
                heartButton.widthAnchor.constraint(
                    equalToConstant: ConstantsConstraint.heartButtonSize
                ),
                heartButton.heightAnchor.constraint(
                    equalToConstant: ConstantsConstraint.heartButtonSize
                )
            ]
        )
    }
    
    private func addStarInRating(countStar: Int) {
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
    
    @objc private func clickHeartButton(){
        guard let delegate, let idNFT else {
            assertionFailure("clickHeartButton")
            delegate?.showErrorAlert(message: LocalizedText.errorAlertRemoveLikeMessage)
            return
        }
        delegate.delete(likeId: idNFT)
    }
}

extension MyFavoritesNFTViewCell {
    private enum ConstantsConstraint {
        static let imageNFTSize: CGFloat = 80
        static let heartButtonSize: CGFloat = 29
        static let infoStackLeftOffset: CGFloat = 12
        static let infoStackWidth: CGFloat = 76
        static let imageStarSize: CGFloat = 12
    }
}
