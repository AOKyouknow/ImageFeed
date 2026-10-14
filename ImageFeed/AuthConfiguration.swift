//
//  Constants.swift
//  ImageFeed
//
//  Created by Алик on 15.08.2026.
//

import Foundation

enum Constants {
    
    static var accessKey: String {
            guard let key = Bundle.main.object(forInfoDictionaryKey: "UnsplashAPIKey") as? String else {
                fatalError("Ошибка: API-ключ не найден в Info.plist")
            }
            return key
        }
    
    static let secretKey = "b-6E5Cf8a8AfLyd-0NEDO0wm_CmeHE9elzDJab6GPXo"
    
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURLString = "https://api.unsplash.com"
    
    static let tokenKey = "tokenKey"
    
    static let httpResponseMinCode = 200
    
    static let httpResponseMaxCode = 300
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    static let buttonIdentifier = "Authenticate"
    
    static let imageViewWidth = 32
}



struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String

    static var standard: AuthConfiguration {
            AuthConfiguration(accessKey: Constants.accessKey,
                                     secretKey: Constants.secretKey,
                                     redirectURI: Constants.redirectURI,
                                     accessScope: Constants.accessScope,
                                     defaultBaseURLString: Constants.defaultBaseURLString,
                                     authURLString: Constants.unsplashAuthorizeURLString
            )
        }
}

