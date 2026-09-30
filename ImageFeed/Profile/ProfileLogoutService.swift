//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Алик on 28.09.2026.
//

import Foundation
import WebKit

class ProfileLogoutService {
    
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        assert(Thread.isMainThread)
        OAuth2TokenStorage().token = nil
        cleanCookies()
        
        ProfileService.shared.clear()
        ProfileImageService.shared.clear()
        ImagesListService.shared.clear()
        
        showSplash()
        
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        DispatchQueue.global(qos: .utility).async {
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        }
        let dataStore = WKWebsiteDataStore.default()
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        
        dataStore.fetchDataRecords(ofTypes: dataTypes) { records in
            records.forEach { record in
                dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: { })
            }
        }
    }
    
    private func showSplash() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            print("[ProfileLogoutService/showSplash]: не нашли key window, экран авторизации не показан")
            return
        }
        
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
}
