//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Алик on 18.09.2026.
//

import Foundation

final class ProfileImageService {
    private (set) var avatarURL: String?
    static let shared = ProfileImageService()
    private init() {}
    private var task: URLSessionTask?
    let token = OAuth2TokenStorage().token
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    struct UserResult: Codable {
        let profileImage: ProfileImage
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImage: Codable {
        let small: String
    }
    
    final func makeProfileImageRequest(username: String) -> URLRequest? {
        guard
            let url = URL(string: "https://api.unsplash.com/users/\(username)")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        guard let token
        else {
            print("token is nil")
            return nil
        }
         
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
            
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let userResult):
                let avatarStringURL = userResult.profileImage.small
                
                self.avatarURL = avatarStringURL
                completion(.success(avatarStringURL))
                
            case .failure(let error):
                print("Не удалось загрузить ссылку на аватарку для пользователя \(username): \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
        
        
        
      
    
    
}//
