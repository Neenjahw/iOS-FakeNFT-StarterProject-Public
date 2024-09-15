
import UIKit

//MARK: - NftCell
final class NftCell: UICollectionViewCell, ReuseIdentifying {
    
    //MARK: - UIConstants
    private enum UIConstants {
        static let nftImageViewCornerRadius: CGFloat = 12
    }
    
    private let nftRating = 5
    
    //MARK: - UIModels
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .nftCardMock)
        imageView.layer.cornerRadius = UIConstants.nftImageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .unFavoriteIcon), for: .normal)
        return button
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
    
    private lazy var nftName: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "Archie"
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
       let label = UILabel()
        label.font = .bodyMedium
        label.text = "1 ETH"
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .cartIcon), for: .normal)
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        setupRatingStars()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupRatingStars() {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<5 {
            let ratingImageView = UIImageView()
            
            if i < nftRating {
                ratingImageView.image = UIImage(resource: .ratingIcon)
            } else {
                ratingImageView.image = UIImage(resource: .ratingIconVoid)
            }
            
            ratingImageView.contentMode = .scaleAspectFit
            ratingImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            ratingImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            ratingStackView.addArrangedSubview(ratingImageView)
        }
    }
}

//MARK: - AutoLayout
extension NftCell {
    private func setupViews() {
        [nftImageView,
         ratingStackView,
         nftName,
         priceLabel,
         cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        nftImageView.addSubview(favoriteButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: frame.width),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            favoriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            
            nftName.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nftName.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            cartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            
        ])
    }
}
