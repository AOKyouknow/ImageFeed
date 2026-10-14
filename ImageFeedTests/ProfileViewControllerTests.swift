//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Алик on 13.10.2026.
//


import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given (Дано)
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
        
        // When (Когда)
        viewController.loadViewIfNeeded()
        
        // Then (Тогда)
        XCTAssertTrue(presenterSpy.viewDidLoadCalled, "Контроллер не вызвал viewDidLoad() презентера")
    }
    
    func testViewControllerCallsDidTapLogoutButton() {
        // Given (Дано)
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
        viewController.loadViewIfNeeded()
        
        // When (Когда)
        viewController.logoutButton.sendActions(for: .touchUpInside)
        
        // Then (Тогда)
        XCTAssertTrue(presenterSpy.didTapLogoutButtonCalled, "Контроллер не сообщил о нажатии")
    }
    
}
