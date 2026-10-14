//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Алик on 12.10.2026.
//
@testable import ImageFeed
import Foundation

class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
        var view: WebViewViewControllerProtocol?
        
        func viewDidLoad() {
            viewDidLoadCalled = true
        }
        
        func didUpdateProgressValue(_ newValue: Double) {
        
        }
        
        func code(from url: URL) -> String? {
            return nil
        }
}
