
import UIKit

protocol NftHeaderCollectionViewDelegate: AnyObject {
    func transitionToAuthorPage()
}

//MARK: - NftHeaderCollectionView
final class NftHeaderCollectionView: UICollectionReusableView, ReuseIdentifying {
    
    //MARK: - UIConstants
    private enum UIConstants {
        static let coverImageViewCornerRadius: CGFloat = 12
    }
    
    //MARK: - Public Properties
    weak var delegate: NftHeaderCollectionViewDelegate?
    
    //MARK: - UIModels
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = UIConstants.coverImageViewCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        return label
    }()
    
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Автор коллекции:"
        return label
    }()
    
    private lazy var authorButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .caption1
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = .bitWidth
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func configure(_ model: NftCollectionModel?) {
        collectionNameLabel.text = model?.name
        authorButton.setTitle(model?.author, for: .normal)
        descriptionLabel.text = model?.description
        coverImageView.kf.setImage(with: model?.cover)
    }
    
    //MARK: - Private methods
    @objc private func didTapAuthorButton() {
        delegate?.transitionToAuthorPage()
    }
}

//MARK: - AutoLayout
extension NftHeaderCollectionView {
    private func setupViews() {
        [placeholderImageView,
         coverImageView,
         collectionNameLabel,
         authorLabel,
         authorButton,
         descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderImageView.heightAnchor.constraint(equalToConstant: 310),
            placeholderImageView.topAnchor.constraint(equalTo: topAnchor),
            placeholderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            coverImageView.heightAnchor.constraint(equalToConstant: 310),
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16),
            collectionNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            authorButton.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 8),
            authorButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            authorButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
        ])
    }
}
