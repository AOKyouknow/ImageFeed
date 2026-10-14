//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Алик on 13.10.2026.
//


import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    var logOutCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
    
    func logOut() {
        logOutCalled = true
    }
}
