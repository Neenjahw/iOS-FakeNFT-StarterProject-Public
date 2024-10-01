//
//  Localizable.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 23.09.2024.
//

import Foundation

struct Localizable {
    private static func localizedString(from value: String) -> String {
        NSLocalizedString(value, comment: "")
    }
    
    // Cart
    
    static let tabBarСart = localizedString(from: "TabBar.cart")
    static let nftCellPrice = localizedString(from: "NftCell.price")
    static let cartPaymentButton = localizedString(from: "Cart.paymentButton")
    
    static let deleteWarning = localizedString(from: "Delete.warning")
    static let deleteDeleteButton = localizedString(from: "Delete.deleteButton")
    static let deleteCancelButton = localizedString(from: "Delete.cancelButton")
    
    static let paymentTitle = localizedString(from: "Payment.title")
    static let paymentAgreementLabel = localizedString(from: "Payment.agreementLabel")
    static let paymentAgreementButton = localizedString(from: "Payment.agreementButton")
    static let paymentPayButton = localizedString(from: "Payment.payButton")
    
    static let sortingTitle = localizedString(from: "Sorting.title")
    static let sortingPrice = localizedString(from: "Sorting.price")
    static let sortingRating = localizedString(from: "Sorting.rating")
    static let sortingName = localizedString(from: "Sorting.name")
    static let sortingCancelButton = localizedString(from: "Sorting.cancelButton")
    
    static let successMessage = localizedString(from: "Success.message")
    static let successButton = localizedString(from: "Success.button")
    
    static let alertCartErrorMessage = localizedString(from: "AlertCartError.message")
    static let alertDeleteErrorMessage = localizedString(from: "AlertDeleteError.message")
    static let alertLoadingCurrenciesErrorMessage = localizedString(from: "AlertLoadingCurrenciesError.message")
    static let alertSelectPaymentMethodErrorMessage = localizedString(from: "AlertSelectPaymentMethodError.message")
    static let alertPayErrorMessage = localizedString(from: "AlertPayError.message")
    static let alertCancelButton = localizedString(from: "Alert.cancelButton")
    static let alertRepeatButton = localizedString(from: "Alert.repeatButton")
    static let alertOkayButton = localizedString(from: "Alert.okayButton")
    
    static let placeholderTextLabel = localizedString(from: "Placeholder.textLabel")
}

