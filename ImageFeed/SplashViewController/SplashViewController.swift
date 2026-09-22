//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Алик on 26.08.2026.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if storage.token != nil {
            guard let token = storage.token else { return }
            fetchProfile(token: token)
        } else {
            let authViewController = AuthViewController()
            authViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: authViewController)
                navigationController.modalPresentationStyle = .fullScreen
            
            present(navigationController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
       let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
       
        window?.rootViewController = TabBarController()
        
        window?.makeKeyAndVisible()
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                
                guard let self = self else { return }
                
                switch result {
                case .success(let profile):
                    
                    let username = profile.username
                    ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in
                    }
                    
                    self.switchToTabBarController()
                    
                case .failure(let error):
                    self.showProfileError(error)
                }
            }
        }
    }
    
    private func showProfileError(_ error: Error) {
        let alert = UIAlertController(
            title: "Не удалось получить профиль",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
