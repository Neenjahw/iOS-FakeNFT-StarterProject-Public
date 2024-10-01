
import UIKit

//MARK: - NftCellDelegate
protocol NftCellDelegate: AnyObject {
    func nftCellDidUpdateLikeStatus(nftId: String)
    func nftCellDidUpdateOrderStatus(nftId: String)
}

//MARK: - NftCell
final class NftCell: UICollectionViewCell, ReuseIdentifying {
    
    //MARK: - UIConstants
    private enum UIConstants {
        static let nftImageViewCornerRadius: CGFloat = 12
    }
    
    //MARK: - Public Properties
    weak var delegate: NftCellDelegate?
    
    //MARK: - Private Properties
    private var nftId: String?
    
    //MARK: - UIModels
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = UIConstants.nftImageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .unFavoriteIcon), for: .normal)
        button.addTarget(self, action: #selector(changeFavorite), for: .touchUpInside)
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
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyMedium
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .cartIcon), for: .normal)
        button.addTarget(self, action: #selector(changeOrder), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Properties
    func configure(_ cellModel: NftCellModel, _ favoritesNFTId: [String], _ order: [String]) {
        nftName.text = cellModel.name
        priceLabel.text = "\(cellModel.price) ETH"
        nftImageView.kf.setImage(with: cellModel.images.first)
        setupRatingStars(cellModel.rating)
        nftId = cellModel.id
        let isLiked = favoritesNFTId.contains(cellModel.id)
        let favoriteImage = isLiked ? UIImage(resource: .favoriteIcon) : UIImage(resource: .unFavoriteIcon)
        favoriteButton.setImage(favoriteImage, for: .normal)
        let isOrdered = order.contains(cellModel.id)
        let orderImage = isOrdered ? UIImage(resource: .deleteCartIcon) : UIImage(resource: .cartIcon)
        cartButton.setImage(orderImage, for: .normal)
    }
    
    //MARK: - Private Properties
    private func setupRatingStars(_ nftRating: Int) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for rating in 0..<5 {
            let ratingImageView = UIImageView()
            
            ratingImageView.image = UIImage(resource: rating < nftRating ? .ratingIcon : .ratingIconVoid)
            
            ratingImageView.contentMode = .scaleAspectFit
            ratingImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            ratingImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            ratingStackView.addArrangedSubview(ratingImageView)
        }
    }
    
    @objc private func changeFavorite() {
        guard let nftId = nftId else { return }
        delegate?.nftCellDidUpdateLikeStatus(nftId: nftId)
    }
    
    @objc private func changeOrder() {
        guard let nftId = nftId else { return }
        delegate?.nftCellDidUpdateOrderStatus(nftId: nftId)
    }
}

//MARK: - AutoLayout
extension NftCell {
    private func setupViews() {
        [placeholderImageView,
         nftImageView,
         favoriteButton,
         ratingStackView,
         nftName,
         priceLabel,
         cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            placeholderImageView.widthAnchor.constraint(equalToConstant: frame.width),
            placeholderImageView.heightAnchor.constraint(equalTo: placeholderImageView.widthAnchor),
            placeholderImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
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
            
            nftName.widthAnchor.constraint(equalTo: ratingStackView.widthAnchor),
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
