//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Алик on 19.08.2026.
//

import UIKit
import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    private lazy var webView = {
        let webView = WKWebView()
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .launchScreen
        progressView.progress = 0.5
        
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //loadAuthView() рефакторинг
        webView.navigationDelegate = self
        presenter?.viewDidLoad()// РЕФАКТОРИНГ
        //updateProgress()// РЕФАКТОРИНГ  !!!!!!!!!!!!!!!!
        
        estimatedProgressObservation = webView.observe(
                    \.estimatedProgress,
                    options: [.new],
                    changeHandler: { [weak self] _, _ in
                        guard let self = self else { return }
                        //self.updateProgress() // !!!!!!!!!!!!!!!
                    }
                )
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                //self.setProgressValue(Float(keyPath ?? "") ?? 0.0) // ???
                //updateProgress() // !!!!!!!!!!!!!!!!!!
                presenter?.didUpdateProgressValue(webView.estimatedProgress)
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
    }
    
//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001}
        
        func setProgressValue(_ newValue: Float) {
            progressView.progress = newValue
        }

        func setProgressHidden(_ isHidden: Bool) {
            progressView.isHidden = isHidden
        }
       
    
    private func setupUI() {
        view.addSubview(webView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
//    private func loadAuthView() {
//        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
//            print("не собрался urlComponents")
//            return
//        }
//        
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope)
//        ]
//        
//        guard let url = urlComponents.url else {
//            print("не собрался url")
//            return
//        }
//        let request = URLRequest(url: url)
//        webView.load(request)
//        
//        updateProgress()
//    }ПЕРЕНЕСЕНО В WebViewPresenter
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("DEBUG URL: \(navigationAction.request.url?.absoluteString ?? "nil")")
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    
}
