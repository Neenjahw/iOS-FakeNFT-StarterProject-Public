//
//  UIViewController+Alert.swift
//  FakeNFT
//
//  Created by gimon on 23.09.2024.
//

import UIKit

extension UIViewController {    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(
            title: LocalizedText.okButton,
            style: .cancel
        )
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
