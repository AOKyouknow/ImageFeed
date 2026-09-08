//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Алик on 26.08.2026.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if storage.token != nil {
            switchToTabBarController()
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
                
        let tabBarController = UITabBarController()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .launchScreen
        appearance.stackedLayoutAppearance.selected.iconColor = .ypWhite
       
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        
        
        let imageListVC = ImagesListViewController()
                
        imageListVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBar2"), tag: 0)

        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBar1"), tag: 1)

        
        tabBarController.viewControllers = [imageListVC, profileVC]
       
        window?.rootViewController = tabBarController
        
        window?.makeKeyAndVisible()
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) { [weak self] in
            self?.switchToTabBarController()
        }
    }
    
   
}
