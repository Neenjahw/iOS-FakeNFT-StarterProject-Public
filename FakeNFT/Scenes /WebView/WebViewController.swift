//
//  WebViewController.swift
//  FakeNFT
//
//  Created by gimon on 22.09.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, LoadingView {
    //MARK: - Visual Components
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private lazy var backButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(font: .bodyBold)
        let image = UIImage(
            systemName: "chevron.left",
            withConfiguration: configuration
        )
        let view = UIButton.systemButton(
            with: image ?? UIImage(),
            target: self,
            action: #selector(clickBackButton)
        )
        view.tintColor = .closeButton
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    //MARK: - Private Properties
    private var url: URL
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        navigationItem.titleView?.backgroundColor = .backgroundColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        activityIndicator.constraintCenters(to: view)
        addConstraintWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        showLoading()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.checkLoadWebView(load: webView.estimatedProgress)
             })
    }
    
    // MARK: - Private Methods
    private func checkLoadWebView(load: Double){
        if abs(load - 1.0) <= 0.01 {
            hideLoading()
        }
    }
    
    private func addConstraintWebView() {
        NSLayoutConstraint.activate(
            [
                webView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor
                ),
                webView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor
                ),
                webView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor
                ),
                webView.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor
                )
            ]
        )
    }
    
    @objc private func clickBackButton() {
        dismiss(animated: true)
    }
}
