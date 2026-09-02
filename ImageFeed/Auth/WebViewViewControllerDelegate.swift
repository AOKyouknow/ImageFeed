//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Алик on 22.08.2026.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)// получил код
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) // пользователь отменил авторизацию
    
}
