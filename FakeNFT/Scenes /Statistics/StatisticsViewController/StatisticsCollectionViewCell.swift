import Kingfisher
import UIKit

final class StatisticsTableViewCell: UITableViewCell {
    
    private lazy var indexLabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var profileImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.tintColor = .greyUniversal
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        return label
    }()
    
    private lazy var nftCountLabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cellBackgroundImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        layer.masksToBounds = true
        layer.cornerRadius = 12
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [cellBackgroundImageView, indexLabel, profileImageView, nameLabel, nftCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            indexLabel.widthAnchor.constraint(equalToConstant: 27),
            indexLabel.heightAnchor.constraint(equalToConstant: 20),
            indexLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            indexLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            cellBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            cellBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellBackgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            cellBackgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 28),
            profileImageView.heightAnchor.constraint(equalToConstant: 28),
            profileImageView.leadingAnchor.constraint(equalTo: cellBackgroundImageView.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: cellBackgroundImageView.topAnchor, constant: 26),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: nftCountLabel.leadingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: cellBackgroundImageView.topAnchor, constant: 26),
            nameLabel.bottomAnchor.constraint(equalTo: cellBackgroundImageView.bottomAnchor, constant: -26),
            
            nftCountLabel.widthAnchor.constraint(equalToConstant: 38),
            nftCountLabel.heightAnchor.constraint(equalToConstant: 28),
            nftCountLabel.trailingAnchor.constraint(equalTo: cellBackgroundImageView.trailingAnchor, constant: -16),
            nftCountLabel.topAnchor.constraint(equalTo: cellBackgroundImageView.topAnchor, constant: 26)
        ])
    }
    
    func configureCell(at index: Int, with user: User) {
        indexLabel.text = "\(index)"
        nftCountLabel.text = "\(user.nfts.count)"
        nameLabel.text = user.name
        if let url = URL(string: user.avatar) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
    }
}
