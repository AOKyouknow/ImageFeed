//
//  AuthHelperSpy.swift
//  ImageFeedTests
//
//  Created by Алик on 12.10.2026.
//
@testable import ImageFeed
import Foundation

final class AuthHelperSpy: AuthHelperProtocol {
    func authRequest() -> URLRequest? {        
        return URLRequest(url: URL(string: "https://example.com")!)
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
