//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Алик on 13.10.2026.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    
    func viewDidLoad()
    func getPhoto(at index: Int) -> Photo
    func getCellHeight(forWidth width: CGFloat, at index: Int) -> CGFloat
    func willDisplayCell(at index: Int)
    func didSelectRow(at index: Int)
    func changeLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void)
}

class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    weak var view: ImagesListViewControllerProtocol?
    
    var photosCount: Int {
            return photos.count
        }
        
        func viewDidLoad() {
            NotificationCenter.default.addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.handlePhotosChange()
            }
            
            imagesListService.fetchPhotosNextPage()
        }
        
        func getPhoto(at index: Int) -> Photo {
            return photos[index]
        }
        
        func getCellHeight(forWidth width: CGFloat, at index: Int) -> CGFloat {
            let photo = photos[index]
            let imageViewHeight = width * (photo.size.height / photo.size.width)
            return imageViewHeight + 8
        }
        
        func willDisplayCell(at index: Int) {
            guard index + 1 == photos.count else { return }
            imagesListService.fetchPhotosNextPage()
        }
        
        func didSelectRow(at index: Int) {
            let photo = photos[index]
            view?.navigateToSingleImage(with: photo)
        }
        
        func changeLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
            let photo = photos[indexPath.row]
            
            imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    let updatedPhoto = self.photos[indexPath.row]
                    view?.updateCellLikeStatus(at: indexPath, isLiked: updatedPhoto.isLiked)
                    completion(true)
                case .failure:
                    view?.showLikeErrorAlert()
                    completion(false)
                }
            }
        }
        
        private func handlePhotosChange() {
            let oldCount = photos.count
            photos = imagesListService.photos
            let newCount = photos.count
            
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    

