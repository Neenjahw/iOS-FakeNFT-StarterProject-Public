//
//  MyFavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by gimon on 22.09.2024.
//

import Foundation

protocol MyFavoritesNFTPresenterProtocol {
    func loadAllMyFavoritesNFT()
    func countMyFavoritesNFT() -> Int
    func getFavoritesNFT(indexArray: Int) -> Nft
    func deleteNFT(likeId: String)
}

final class MyFavoritesNFTPresenter: MyFavoritesNFTPresenterProtocol {
    weak var myFavoritesNFTViewController: MyFavoritesNFTViewControllerProtocol?
    
    private var nftService: NftService
    private var editProfileServices: EditProfileServices
    private var myFavoritesNFTIDArray: [String]
    private var myFavoritesNFTArray: [Nft] = []
    private var countLoadedNFT = 0
    
    init(
        nftService: NftService,
        editProfileServices: EditProfileServices,
        myFavoritesNFTIDArray: [String]
    ) {
        self.nftService = nftService
        self.editProfileServices = editProfileServices
        self.myFavoritesNFTIDArray = myFavoritesNFTIDArray
    }
    
    func loadAllMyFavoritesNFT() {
        if myFavoritesNFTIDArray.isEmpty {
            myFavoritesNFTViewController?.showMyNFT(isEmpty: myFavoritesNFTArray.isEmpty)
            return
        }
        countLoadedNFT = 0
        for id in myFavoritesNFTIDArray {
            loadNft(id: id)
        }
    }
    
    func countMyFavoritesNFT() -> Int {
        myFavoritesNFTArray.count
    }
    
    func getFavoritesNFT(indexArray: Int) -> Nft {
        myFavoritesNFTArray[indexArray]
    }
    
    func deleteNFT(likeId: String) {
        guard let indexRemoveLike = myFavoritesNFTIDArray.firstIndex(of: likeId) else {
            return
        }
        myFavoritesNFTIDArray.remove(at: indexRemoveLike)
        editProfileServices.sendEditProfileRequest(
            name: nil,
            description: nil,
            website: nil,
            avatar: nil,
            likes: myFavoritesNFTIDArray
        ){[weak self] result in
            switch result {
            case .success (let profile):
                self?.myFavoritesNFTIDArray = profile.likes
                self?.myFavoritesNFTArray = []
                self?.loadAllMyFavoritesNFT()
            case .failure (let error):
                self?.myFavoritesNFTViewController?.showErrorAlert(
                    message: LocalizedText.errorAlertRemoveLikeMessage
                )
                assertionFailure("\(error)")
            }
        }
    }
    
    private func loadNft(id: String) {
        nftService.loadNft(id: id) {[weak self] result in
            guard let self else {
                assertionFailure("nftService.loadNft self nil")
                return
            }
            switch result {
            case .success(let nft):
                self.myFavoritesNFTArray.append(nft)
            case.failure(let error):
                assertionFailure("\(error)")
            }
            self.countLoadedNFT += 1
            if self.countLoadedNFT == self.myFavoritesNFTIDArray.count {
                self.myFavoritesNFTViewController?.showMyNFT(isEmpty: self.myFavoritesNFTArray.isEmpty)
                let countNftError = self.myFavoritesNFTIDArray.count - self.myFavoritesNFTArray.count
                if countNftError > 0 {
                    self.myFavoritesNFTViewController?.showErrorAlert(
                        message: "\(LocalizedText.errorAlertMessage) \(countNftError) \(LocalizedText.nft)"
                    )
                }
            }
        }
    }
}
