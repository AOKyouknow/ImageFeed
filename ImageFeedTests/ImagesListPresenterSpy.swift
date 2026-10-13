//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Алик on 13.10.2026.
//

import Foundation

import Foundation
import UIKit
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var didSelectRowCalled = false
    var didSelectRowIndex: Int?
    
    var photosCount: Int { return 3 }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getPhoto(at index: Int) -> Photo {
        return Photo(
            id: "test",
            size: CGRect(x: .zero, y: .zero, width: 100, height: 100),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "https://example.com",
            fullImageURL: "https://example.com",
            isLiked: false
        )
    }
    
    func getCellHeight(forWidth width: CGFloat, at index: Int) -> CGFloat {
        return 200
    }
    
    func willDisplayCell(at index: Int) {}
    
    func didSelectRow(at index: Int) {
        didSelectRowCalled = true
        didSelectRowIndex = index
    }
    
    func changeLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {}
}
