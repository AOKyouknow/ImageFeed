//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Алик on 17.08.2026.
//

import UIKit

final class AuthViewController: UIViewController {
    
    let logoOfUnsplash: UIImageView = {
        let logoOfUnsplash = UIImageView()
        logoOfUnsplash.image = UIImage(resource: .logoOfUnsplash)
        logoOfUnsplash.translatesAutoresizingMaskIntoConstraints = false
        return logoOfUnsplash
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 17)
        loginButton.setTitleColor(UIColor(resource: .ypBlack), for: .normal)
        
        loginButton.backgroundColor = UIColor.white
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 16
        
        let buttonAction = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(WebViewViewController(), animated: true)
        }
        loginButton.addAction(buttonAction, for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    let webViewViewController = WebViewViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureBackButton()
        webViewViewController.delegate = self
    }
    
    func setupUI() {
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

extension AuthViewController: WebViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
