//
//  DeletePresenter.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 11.09.2024.
//

import UIKit

protocol DeletePresenterProtocol {
    var image: UIImage { get }
    
    func handleDeleteButtonTapped()
}

final class DeletePresenter: DeletePresenterProtocol {
    let image: UIImage
    var removePositionClosure: ((String) -> Void)?
    
    private let id: String
    private let servicesAssembly: ServicesAssembly
    private weak var view: DeleteViewProtocol?

    init(view: DeleteViewProtocol, servicesAssembly: ServicesAssembly, image: UIImage, id: String) {
        self.view = view
        self.servicesAssembly = servicesAssembly
        self.image = image
        self.id = id
    }

    func handleDeleteButtonTapped() {
        removePositionClosure?(id)
    }
}
