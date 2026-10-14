//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Алик on 13.10.2026.
//

import Foundation

import XCTest
@testable import ImageFeed

final class ImagesListViewControllerTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ImagesListViewController()
        let presenterSpy = ImagesListPresenterSpy()
        
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
        
        // When
        viewController.loadViewIfNeeded()
        
        // Then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled, "Контроллер не вызвал viewDidLoad() презентера")
    }
    
    func testViewControllerCallsDidSelectRow() {
        // Given
        let viewController = ImagesListViewController()
        let presenterSpy = ImagesListPresenterSpy()
        
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
        
        viewController.loadViewIfNeeded()
        
        let tableView = UITableView()
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        viewController.tableView(tableView, didSelectRowAt: indexPath)
        
        // Then
        XCTAssertTrue(presenterSpy.didSelectRowCalled, "Контроллер не сообщил Презентеру о выборе строки таблицы")
        XCTAssertEqual(presenterSpy.didSelectRowIndex, 0, "Контроллер передал неверный индекс строки в Презентер")
    }
}
