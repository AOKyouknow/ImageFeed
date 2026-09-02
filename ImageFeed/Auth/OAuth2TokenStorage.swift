//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Алик on 26.08.2026.
//

import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get{
            return UserDefaults.standard.string(forKey: Constants.tokenKey)
        }
        
        set{
            if let newToken = newValue {
                UserDefaults.standard.set(newToken, forKey: Constants.tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.tokenKey)
            }
        }
    }
    
}
