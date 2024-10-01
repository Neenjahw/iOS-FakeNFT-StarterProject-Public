import Kingfisher
import UIKit

final class StatisticsCollectionViewCell: UICollectionViewCell {
    
    private var isLiked = false
    private var isInCart = false
    static let reuseIdentifier = "statisticsCollectionViewCellIdentifier"
    
    private lazy var nftImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var likeButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var ratingImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        return label
    }()
    
    private lazy var priceLabel = {
        let label = UILabel()
        label.font = UIFont.caption3
        return label
    }()
    
    private lazy var cartButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cartButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for nft: NFTModel) {
        nftImageView.kf.setImage(with: URL(string: nft.images[0]))
        ratingImageView.image = UIImage(named: "\(nft.rating)")
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        likeButton.setImage(UIImage(named: "likesOff"), for: .normal)
        cartButton.setImage(UIImage(named: "emptyCart"), for: .normal)
    }
    
    private func setupConstraints() {
        [nftImageView, likeButton, ratingImageView, nameLabel, priceLabel, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -1),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 1),
            
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            ratingImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            ratingImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -40),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            nameLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: ratingImageView.trailingAnchor),
            
            priceLabel.heightAnchor.constraint(equalToConstant: 12),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            cartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor)
        ])
    }
    
    private func updateLikeButton() {
        let image = isLiked ? UIImage(named: "likesOn") : UIImage(named: "likesOff")
        likeButton.setImage(image, for: .normal)
    }
    
    private func updateCartButton() {
        let image = isInCart ? UIImage(named: "crossCart") : UIImage(named: "emptyCart")
        cartButton.setImage(image, for: .normal)
    }
    
    @objc
    private func likeButtonDidTap() {
        isLiked.toggle()
        updateLikeButton()
    }
    
    @objc
    private func cartButtonDidTap() {
        isInCart.toggle()
        updateCartButton()
    }
}

