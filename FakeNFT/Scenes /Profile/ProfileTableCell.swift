//
//  ProfileTableCell.swift
//  FakeNFT
//
//  Created by gimon on 07.09.2024.
//

import UIKit

final class ProfileTableCell: UITableViewCell {
    
    //MARK: - Visual Components
    private var textLabelCell: UILabel = {
        let view = UILabel()
        view.font = .bodyBold
        view.textColor = .closeButton
        return view
    }()
    
    
    private var imageChevron: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let view = UIImageView(image: image)
        view.tintColor = .closeButton
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .backgroundColor
        
        [
            textLabelCell,
            imageChevron
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        addConstraintTextLabelCell()
        addConstraintImageChevron()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setTextInCell(text: String) {
        textLabelCell.text = text
    }
    
    // MARK: - Private Methods
    private func addConstraintTextLabelCell() {
        NSLayoutConstraint.activate(
            [
                textLabelCell.centerYAnchor.constraint(
                    equalTo: centerYAnchor
                ),
                textLabelCell.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                )
            ]
        )
    }
    
    private func addConstraintImageChevron() {
        NSLayoutConstraint.activate(
            [
                imageChevron.centerYAnchor.constraint(
                    equalTo: centerYAnchor
                ),
                imageChevron.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -ConstantsConstraint.defaultOffset
                )
            ]
        )
    }
}

extension ProfileTableCell {
    private enum ConstantsConstraint {
        static let defaultOffset: CGFloat = 16
    }
}
