//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Алик on 21.09.2026.
//

import Foundation

class ImageListService {
    var task: URLSessionTask?
    struct Photo { // структура для UI части приложения
        let id: String
        let size: CGRect
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        let isLiked: Bool
    }
    
    struct PhotosResult: Codable { // структура для декодинга JSON
    let id: String
        let width: Int
        let height: Int
        let createdAt: Date?
        let description: String?
        let urls: UrlsResult
        let likedByUser: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, width, height, description, urls
            case createdAt = "created_at"
            case likedByUser = "liked_by_user"
        }
    
        
    }
    struct UrlsResult: Codable {
        let thumb: String
        let full: String
    }
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard task == nil else { return }
        guard let token = OAuth2TokenStorage().token else { return }
        guard var components = URLComponents(string: "https://api.unsplash.com/photos") else { return }
        components.queryItems = [
            URLQueryItem(name: "page", value: String(nextPage)),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [ weak self ] (result: Result<[PhotosResult],Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photosResultArray):
                let photosResult = photosResultArray.map { photo in
                    return Photo(
                        id: photo.id,
                        size: CGRect(x: .zero, y: .zero, width: photo.width, height: photo.height),
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.description,
                        thumbImageURL: photo.urls.thumb,
                        largeImageURL: photo.urls.full,
                        isLiked: photo.likedByUser)
                }
                self.photos.append(contentsOf: photosResult)
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(
                    name: ImageListService.didChangeNotification,
                    object: self)
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
        
    }
    
    
}
