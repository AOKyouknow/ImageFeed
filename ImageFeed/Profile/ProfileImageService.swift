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
            
        let task = URLSession.shared.dataTask(with: request) { [ weak self ] data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.urlSessionError))
                    return
                }
                guard (Constants.httpResponseMinCode..<Constants.httpResponseMaxCode).contains(httpResponse.statusCode)
                else {
                    completion(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
                    return
                }
                
                guard let data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(UserResult.self, from: data)
                    self?.avatarURL = response.profileImage.small
                    completion(.success(response.profileImage.small))
                    NotificationCenter.default                                     // 1
                        .post(                                                     // 2
                            name: ProfileImageService.didChangeNotification,       // 3
                            object: self,                                          // 4
                            userInfo: ["URL": response.profileImage.small])                    // 5

                } catch {
                    completion(.failure(error))
                }
                self?.task = nil// почему здесь обнуляется? потому что ассинхронный код.
            }
        }
        
        self.task = task
        task.resume()
    }
        
        
        
      
    
    
}//
