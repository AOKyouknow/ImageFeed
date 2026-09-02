//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Алик on 17.08.2026.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2Service = OAuth2Service.shared
    private let webViewViewController = WebViewViewController()
    
    private let logoOfUnsplash: UIImageView = {
        let logoOfUnsplash = UIImageView()
        logoOfUnsplash.image = UIImage(resource: .logoOfUnsplash)
        logoOfUnsplash.translatesAutoresizingMaskIntoConstraints = false
        return logoOfUnsplash
    }()
    
   private lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 17)
        loginButton.setTitleColor(UIColor(resource: .ypBlack), for: .normal)
        
        loginButton.backgroundColor = UIColor.white
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 16
        
        let buttonAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(self.webViewViewController, animated: true)
        }
        loginButton.addAction(buttonAction, for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureBackButton()
        webViewViewController.delegate = self
    }
    
    private func setupUI() {
        view.addSubview(logoOfUnsplash)
        view.addSubview(loginButton)
        
        
        logoOfUnsplash.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoOfUnsplash.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .navBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .navBackButton)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(resource: .ypBlack)
        
        
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    print("got token")
                    
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didAuthenticate(self)
                    
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
