
import UIKit

//MARK: - CatalogCell
final class NftCatalogCell: UITableViewCell, ReuseIdentifying {
    
    //MARK: - UIConstants
    private enum UIConstants {
        static let nftCollectionImageViewCornerRadius: CGFloat = 12
    }
    
    //MARK: - UIModels
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var nftCollectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = UIConstants.nftCollectionImageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public func
    func configure(with cellModel: NftCatalogCellModel) {
        nftCollectionImageView.kf.setImage(with: cellModel.cover)
        nftCountLabel.text = "\(cellModel.name) (\(cellModel.nfts.count))"
    }
}

//MARK: - AutoLayout
extension NftCatalogCell {
    private func setupViews() {
        [placeholderImageView,
         nftCollectionImageView,
         nftCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderImageView.heightAnchor.constraint(equalToConstant: 150),
            placeholderImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeholderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeholderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nftCollectionImageView.heightAnchor.constraint(equalToConstant: 150),
            nftCollectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCollectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCollectionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nftCountLabel.topAnchor.constraint(equalTo: nftCollectionImageView.bottomAnchor, constant: 4),
            nftCountLabel.leadingAnchor.constraint(equalTo: nftCollectionImageView.leadingAnchor),
        ])
    }
}
