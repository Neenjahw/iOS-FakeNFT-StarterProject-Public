//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 23.09.2024.
//

import UIKit

class AlertPresenter {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(title: String, message: String = "", actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let viewController = self.viewController else { return }
            viewController.present(alertController, animated: true)
        }
    }
    
    func createAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}
