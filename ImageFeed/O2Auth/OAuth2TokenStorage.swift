//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Алик on 26.08.2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private enum Keys {
        static let token = "bearerToken"
    }
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.token)
        }
        set {
            if let newValue = newValue {
                let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.token)
                
                if !isSuccess {
                    print("Не удалось сохранить токен в Keychain")
                }
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token)
            }
        }
    }
}
