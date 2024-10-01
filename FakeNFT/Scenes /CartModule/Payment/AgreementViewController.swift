//
//  AgreementViewController.swift
//  FakeNFT
//
//  Created by Vladislav Kramskoy on 14.09.2024.
//

import UIKit
import WebKit

final class AgreementViewController: UIViewController, WKNavigationDelegate {
    private let agreementURL = "https://yandex.ru/legal/practicum_termsofuse"
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .white
        view.addSubview(webView)
        setupNavigationBar()
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let url = URL(string: agreementURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = .none
    }
    
    private func setupNavigationBar() {
        let iconImage = UIImage(named: "backButton")
        let barButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(backButtonTapped))
        barButtonItem.tintColor = UIColor.blackLight
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

