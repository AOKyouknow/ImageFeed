//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Алик on 10.09.2026.
//

import UIKit
import ProgressHUD

class UIBlockingProgressHUD {
    private static var window: UIWindow?  { //поиск активного окна
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return nil
        }
        return sceneDelegate.window
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
}
