//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by gimon on 13.09.2024.
//

import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {
    //MARK: - Visual Components
    private lazy var tapGesture = UITapGestureRecognizer(
        target: view,
        action: #selector(view.endEditing)
    )
    
    private lazy var closeButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(font: .bodyBold)
        let image = UIImage(
            systemName: "xmark",
            withConfiguration: configuration
        )
        let view = UIButton.systemButton(
            with: image ?? UIImage(),
            target: self,
            action: #selector(clickCloseButton)
        )
        view.backgroundColor = .backgroundColor
        view.tintColor = .segmentActive
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .backgroundColor
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.alwaysBounceVertical = true
        return view
    }()
    
    private lazy var imageProfile: UIImageView = {
        let url = URL(string: profilePresenter.profileData?.avatar ?? "")
        let view = UIImageView()
        view.kf.setImage(with: url)
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .backgroundEditProfileImage
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.setTitle("Сменить\nфото", for: .normal)
        view.titleLabel?.font = .bodyMedium
        view.titleLabel?.textColor = .white
        view.titleLabel?.numberOfLines = 2
        view.titleLabel?.textAlignment = .center
        view.addTarget(
            self,
            action: #selector(clickEditAvatarButton),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var userNameTittle: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .headline3
        view.text = LocalizedText.tittleName
        return view
    }()
    
    private lazy var userName: UITextField = {
        let view = UITextField()
        view.backgroundColor = .segmentInactive
        view.layer.cornerRadius = 12
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        view.leftView = leftView
        view.leftViewMode = .always
        view.font = .bodyRegular
        view.text = profilePresenter.profileData?.name
        view.clearButtonMode = .whileEditing
        return view
    }()
    
    private lazy var descriptionTittle: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .headline3
        view.text = LocalizedText.tittleDescription
        return view
    }()
    
    private lazy var editDescriptionView: UITextView = {
        let view = UITextView()
        view.text = profilePresenter.profileData?.description
        view.textContainer.lineFragmentPadding = 16
        view.isEditable = true
        view.backgroundColor = .segmentInactive
        view.isScrollEnabled = true
        view.font = .bodyRegular
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var siteTittle: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .headline3
        view.text = LocalizedText.tittleSite
        return view
    }()
    
    private lazy var editSiteField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .segmentInactive
        view.layer.cornerRadius = 12
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        view.leftView = leftView
        view.leftViewMode = .always
        view.font = .bodyRegular
        view.text = profilePresenter.profileData?.website
        view.clearButtonMode = .whileEditing
        return view
    }()
    
    //MARK: - Private Property
    private var urlString: String?
    private let profilePresenter: ProfilePresenterProtocol
    
    //MARK: - Initialization
    init(profilePresenter: ProfilePresenterProtocol) {
        self.profilePresenter = profilePresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        [
            closeButton,
            scrollView
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [
            imageProfile,
            editAvatarButton,
            userNameTittle,
            userName,
            descriptionTittle,
            editDescriptionView,
            siteTittle,
            editSiteField
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        userName.delegate = self
        editSiteField.delegate = self
        editDescriptionView.delegate = self
        
        addConstraintCloseButton()
        addConstraintScrollView()
        addConstraintImageProfile()
        addConstraintEditAvatarButton()
        addConstraintTittle(
            topView: editAvatarButton,
            currentView: userNameTittle
        )
        addConstraintTextField(
            tittleView: userNameTittle,
            currentView: userName
        )
        addConstraintTittle(
            topView: userName,
            currentView: descriptionTittle
        )
        addConstraintTextField(
            tittleView: descriptionTittle,
            currentView: editDescriptionView
        )
        addConstraintTittle(
            topView: editDescriptionView,
            currentView: siteTittle
        )
        addConstraintTextField(
            tittleView: siteTittle,
            currentView: editSiteField
        )
    }
    
    //MARK: - Private Methods
    @objc private func clickCloseButton() {
        if let oldProfile = profilePresenter.profileData {
            if userName.text != oldProfile.name ||
                editDescriptionView.text != oldProfile.description ||
                editSiteField.text != oldProfile.website ||
                urlString != oldProfile.avatar {
                let profile = ProfileData(
                    name: userName.text ?? "",
                    avatar: urlString ?? oldProfile.avatar,
                    description: editDescriptionView.text,
                    website: editSiteField.text ?? "",
                    nfts: oldProfile.nfts,
                    likes: oldProfile.likes,
                    id: oldProfile.id
                )
                profilePresenter.editProfile(profile: profile)
            }
        } else {
            assertionFailure("error profilePresenter.profileData nil")
        }
        self.dismiss(animated: true)
    }
    
    @objc private func clickEditAvatarButton() {
        self.present(alert(), animated: true)
    }
    
    private func addConstraintCloseButton() {
        NSLayoutConstraint.activate(
            [
                closeButton.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: ConstantsConstraint.defaultOffset
                ),
                closeButton.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -ConstantsConstraint.defaultOffset
                ),
                closeButton.heightAnchor.constraint(
                    equalToConstant: ConstantsConstraint.closeButtonHeightWidth
                ),
                closeButton.widthAnchor.constraint(
                    equalToConstant: ConstantsConstraint.closeButtonHeightWidth
                )
            ]
        )
    }
    
    private func addConstraintScrollView() {
        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(
                    equalTo: closeButton.bottomAnchor
                ),
                scrollView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor
                ),
                scrollView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor
                ),
                scrollView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor
                ),
            ]
        )
    }
    
    private func addConstraintImageProfile() {
        NSLayoutConstraint.activate(
            [
                imageProfile.centerXAnchor.constraint(
                    equalTo: editAvatarButton.centerXAnchor
                ),
                imageProfile.centerYAnchor.constraint(
                    equalTo: editAvatarButton.centerYAnchor
                ),
                imageProfile.heightAnchor.constraint(
                    equalToConstant: ConstantsConstraint.editAvatarButtonHeightWidth
                ),
                imageProfile.widthAnchor.constraint(
                    equalToConstant: ConstantsConstraint.editAvatarButtonHeightWidth
                )
            ]
        )
    }
    
    private func addConstraintEditAvatarButton() {
        NSLayoutConstraint.activate(
            [
                editAvatarButton.topAnchor.constraint(
                    equalTo: scrollView.topAnchor,
                    constant: ConstantsConstraint.topEditAvatarButtonOffset
                ),
                editAvatarButton.centerXAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.centerXAnchor
                ),
                editAvatarButton.heightAnchor.constraint(
                    equalToConstant: ConstantsConstraint.editAvatarButtonHeightWidth
                ),
                editAvatarButton.widthAnchor.constraint(
                    equalToConstant: ConstantsConstraint.editAvatarButtonHeightWidth
                )
            ]
        )
    }
    
    private func addConstraintTittle(topView: UIView, currentView: UIView) {
        NSLayoutConstraint.activate(
            [
                currentView.topAnchor.constraint(
                    equalTo: topView.bottomAnchor,
                    constant: ConstantsConstraint.topTittleOffset
                ),
                currentView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                )
            ]
        )
    }
    
    private func addConstraintTextField(tittleView: UIView, currentView: UIView) {
        
        let heightView = tittleView == descriptionTittle ?
        ConstantsConstraint.textViewHeight :
        ConstantsConstraint.userTextFieldHeight
        
        NSLayoutConstraint.activate(
            [
                currentView.topAnchor.constraint(
                    equalTo: tittleView.bottomAnchor,
                    constant: ConstantsConstraint.topTextEditOffset
                ),
                currentView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                ),
                currentView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -ConstantsConstraint.defaultOffset
                ),
                currentView.heightAnchor.constraint(
                    equalToConstant: heightView
                )
            ]
        )
    }
    
}

extension EditProfileViewController {
    private enum ConstantsConstraint {
        static let closeButtonHeightWidth: CGFloat = 42
        static let editAvatarButtonHeightWidth: CGFloat = 70
        static let topEditAvatarButtonOffset: CGFloat = 22
        static let defaultOffset: CGFloat = 16
        static let topTextEditOffset: CGFloat = 8
        static let userTextFieldHeight: CGFloat = 44
        static let topTittleOffset: CGFloat = 24
        static let textViewHeight: CGFloat = 132
    }
}

//MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addGestureRecognizer(tapGesture)
        let textFieldY = textField.frame.origin.y
        let keyboardHeight = textField.convert(textField.bounds, to: view).maxY - textFieldY
        
        if keyboardHeight > 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = 0
        view.removeGestureRecognizer(tapGesture)
        return true
    }
}

//MARK: - UITextViewDelegate
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        view.addGestureRecognizer(tapGesture)
        let textViewY = textView.frame.origin.y
        let keyboardHeight = textView.convert(textView.bounds, to: view).maxY - textViewY
        
        if keyboardHeight > 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight
            }
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.frame.origin.y = 0
        view.removeGestureRecognizer(tapGesture)
        return true
    }
}

//MARK: - UIAlertController
extension EditProfileViewController {
    private func alert() -> UIAlertController {
        let alert = UIAlertController(
            title: LocalizedText.tittleAlert,
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: LocalizedText.cancelButton,
                style: .cancel,
                handler: nil
            )
        )
        
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = LocalizedText.alertPlaceholder
        })
        
        alert.addAction(
            UIAlertAction(title: LocalizedText.okButton,
                          style: .default,
                          handler: {
                              [weak self] action in
                              
                              if let link = alert.textFields?.first?.text {
                                  self?.urlString = link
                                  self?.imageProfile.kf.setImage(with: URL(string: link))
                              }
                          }
                         )
        )
        return alert
    }    
}
