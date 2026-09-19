//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Алик on 20.09.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .launchScreen
        appearance.stackedLayoutAppearance.selected.iconColor = .ypWhite

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        let imageListVC = ImagesListViewController()
        imageListVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBar2"), tag: 0)

        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBar1"), tag: 1)

        viewControllers = [imageListVC, profileVC]
    }
}
