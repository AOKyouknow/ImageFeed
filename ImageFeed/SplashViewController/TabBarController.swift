//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Алик on 20.09.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureViewControllers()
    }
    
    // MARK: - Private Methods
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .launchScreen
        appearance.stackedLayoutAppearance.selected.iconColor = .ypWhite
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func configureViewControllers() {
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabBar2"),
            tag: 0
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabBar1"),
            tag: 1
        )
        
        viewControllers = [
            imagesListViewController,
            profileViewController
        ]
    }
}
