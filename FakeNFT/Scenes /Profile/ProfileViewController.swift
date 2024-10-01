//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by gimon on 07.09.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject, LoadingView {
    func updateProfile()
    func hideViewElements()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    //MARK: - Visual Components
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private lazy var editProfileButton: UIButton = {
        guard let image = UIImage(named: "edit") else {
            assertionFailure("error create image editProfileButton")
            return UIButton()
        }
        let view = UIButton.systemButton(
            with: image,
            target: self,
            action: #selector(clickEditProfileButton)
        )
        view.tintColor = .closeButton
        view.isHidden = true
        return view
    }()
    
    private lazy var imageProfile: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private lazy var userName: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .headline3
        view.textAlignment = .left
        view.isHidden = true
        return view
    }()
    
    private lazy var userDescription: UILabel = {
        let view = UILabel()
        view.textColor = .closeButton
        view.font = .caption2
        view.textAlignment = .left
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    private lazy var siteButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .backgroundColor
        view.setTitleColor(.siteBlue, for: .normal)
        view.titleLabel?.font = .caption1
        view.addTarget(
            self,
            action: #selector(openSite),
            for: .touchUpInside
        )
        view.isHidden = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .backgroundColor
        view.separatorStyle = .none
        view.isHidden = true
        return view
    }()
    
    //MARK: - Private Property
    private let cellReuseIdentifier = "profileCellReuseIdentifier"
    private var presenter: ProfilePresenterProtocol
    
    //MARK: - Initialization
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        presenter.viewController = self
        
        [
            editProfileButton,
            imageProfile,
            userName,
            userDescription,
            siteButton,
            tableView,
            activityIndicator
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableView.register(
            ProfileTableCell.self,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.constraintCenters(to: view)
        addConstraintEditProfileButton()
        addConstraintImageProfile()
        addConstraintUserName()
        addConstraintUserDescription()
        addConstraintSiteButton()
        addConstraintTableView()
        
        self.showLoading()
        presenter.loadProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideViewElements()
        self.showLoading()
        presenter.loadProfile()
    }
    
    func updateProfile() {
        if let profile: ProfileData = presenter.profileData {
            let url = URL(string: profile.avatar)
            imageProfile.kf.setImage(with: url)
            userName.text = profile.name
            userDescription.text = profile.description
            let site = URLComponents(string: profile.website)
            siteButton.setTitle(site?.host ?? profile.website, for: .normal)
            tableView.reloadData()
            [
                editProfileButton,
                imageProfile,
                userName,
                userDescription,
                siteButton,
                tableView
            ].forEach{
                $0.isHidden = false
            }
            self.hideLoading()
        }
    }
    
    func hideViewElements() {
        [
            editProfileButton,
            imageProfile,
            userName,
            userDescription,
            siteButton,
            tableView
        ].forEach{
            $0.isHidden = true
        }
        self.showLoading()
    }
    
    //MARK: - Private Methods
    @objc private func clickEditProfileButton(){
        let viewController = EditProfileViewController(profilePresenter: presenter)
        present(viewController, animated: true)
        
    }
    
    @objc private func openSite() {
        if let url = URL(string: presenter.profileData?.website ?? "") {
            let wv = WebViewController(url: url)
            let nc = UINavigationController(rootViewController: wv)
            nc.modalPresentationStyle = .fullScreen
            present(nc, animated: true)
        } else {
            showErrorAlert(message: LocalizedText.errorWebViewAlertMessage)
        }
    }
    
    private func addConstraintEditProfileButton(){
        NSLayoutConstraint.activate(
            [
                editProfileButton.widthAnchor.constraint(
                    equalToConstant: ConstantsConstraint.widthButton
                ),
                editProfileButton.heightAnchor.constraint(
                    equalToConstant: ConstantsConstraint.heightButton
                ),
                editProfileButton.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: ConstantsConstraint.topButtonOffset
                ),
                editProfileButton.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -ConstantsConstraint.trailingButtonOffset
                )
            ]
        )
    }
    
    private func addConstraintImageProfile(){
        NSLayoutConstraint.activate(
            [
                imageProfile.widthAnchor.constraint(
                    equalToConstant: ConstantsConstraint.widthImage
                ),
                imageProfile.heightAnchor.constraint(
                    equalToConstant: ConstantsConstraint.heightImage
                ),
                imageProfile.topAnchor.constraint(
                    equalTo: editProfileButton.bottomAnchor,
                    constant: ConstantsConstraint.topImageOffset
                ),
                imageProfile.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                )
            ]
        )
    }
    
    private func addConstraintUserName(){
        NSLayoutConstraint.activate(
            [
                userName.centerYAnchor.constraint(
                    equalTo: imageProfile.centerYAnchor
                ),
                userName.leadingAnchor.constraint(
                    equalTo: imageProfile.trailingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                )
            ]
        )
    }
    
    private func addConstraintUserDescription(){
        NSLayoutConstraint.activate(
            [
                userDescription.topAnchor.constraint(
                    equalTo: imageProfile.bottomAnchor,
                    constant: ConstantsConstraint.topDescriptionOffset
                ),
                userDescription.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                ),
                userDescription.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -ConstantsConstraint.defaultOffset
                )
            ]
        )
    }
    
    private func addConstraintSiteButton(){
        NSLayoutConstraint.activate(
            [
                siteButton.topAnchor.constraint(
                    equalTo: userDescription.bottomAnchor,
                    constant: ConstantsConstraint.topSiteButtonOffset
                ),
                siteButton.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: ConstantsConstraint.defaultOffset
                ),
                siteButton.heightAnchor.constraint(
                    equalToConstant: ConstantsConstraint.siteButtonHeight
                )
            ]
        )
    }
    
    private func addConstraintTableView(){
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(
                    equalTo: siteButton.bottomAnchor,
                    constant: ConstantsConstraint.topTableOffset
                ),
                tableView.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor
                ),
                tableView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor
                ),
                tableView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor
                )
            ]
        )
    }
}

extension ProfileViewController {
    private enum ConstantsConstraint {
        static let defaultOffset: CGFloat = 16
        static let widthButton: CGFloat = 42
        static let heightButton: CGFloat = 42
        static let topButtonOffset: CGFloat = 2
        static let trailingButtonOffset: CGFloat = 9
        static let widthImage: CGFloat = 70
        static let heightImage: CGFloat = 70
        static let topImageOffset: CGFloat = 20
        static let topDescriptionOffset: CGFloat = 20
        static let topTableOffset: CGFloat = 44
        static let topSiteButtonOffset: CGFloat = 12
        static let siteButtonHeight: CGFloat = 20
    }
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let myNFTc = presenter.getMyNftController()
            let nc = UINavigationController(rootViewController: myNFTc)
            nc.modalPresentationStyle = .fullScreen
            present(nc, animated: true)
        case 1:
            let myFavoritesNFTc = presenter.getMyFavoritesNftController()
            let nc = UINavigationController(rootViewController: myFavoritesNFTc)
            nc.modalPresentationStyle = .fullScreen
            present(nc, animated: true)
        case 2:
            openSite()
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.cellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? ProfileTableCell else {
            return UITableViewCell()
        }
        let text = presenter.getTextCell(number: indexPath.row)
        cell.setTextInCell(text: text)
        return cell
    }
}
