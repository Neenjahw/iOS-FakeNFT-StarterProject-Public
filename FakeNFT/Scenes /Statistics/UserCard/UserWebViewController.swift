import UIKit
import WebKit

final class UserWebViewController: UIViewController, WKNavigationDelegate {
    
    private var webView = WKWebView()
    private lazy var progressView = UIProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupUI()
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress(for: webView.estimatedProgress)
        }
    }
    
    private func setupUI() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: webView.topAnchor)
        ])
    }
    
    func loadWebsite(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    private func updateProgress(for newValue: Double) {
        let progressValue = Float(newValue)
        let shouldHideProgress = isProgressComplete(for: progressValue)
        updateProgressView(progressValue, hidden: shouldHideProgress)
    }
    
    private func updateProgressView(_ value: Float, hidden: Bool) {
        progressView.progress = value
        progressView.isHidden = hidden
    }
    
    private func isProgressComplete(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateProgressView(0.0, hidden: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateProgressView(1.0, hidden: true)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
}
