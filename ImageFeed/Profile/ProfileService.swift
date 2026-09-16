//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Алик on 15.09.2026.
//

import Foundation

final class ProfileService {
    
    let token = OAuth2TokenStorage().token
    var task: URLSessionTask?
    
    struct ProfileResult: Codable {
        let userName: String
        let firstName: String
        let lastName: String
        let bio: String?
        enum CodingKeys: String, CodingKey {
                case userName = "username"
                case firstName = "first_name"
                case lastName = "last_name"
                case bio
            }
    }
    
    struct Profile {
        let username: String
        var name: String
        var loginName: String
        let bio: String?
    }
    
    
    final func makeProfileRequest(token: String?) -> URLRequest? {
        guard
            let url = URL(string: "https://api.unsplash.com/me")
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
    
    
    final func fetchProfile(
        _ token: String, completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest)) // разобраться с ошибкой
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
                    let response = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let profileResult = Profile(
                        username: response.userName,
                        name: "\(response.firstName) \(response.lastName)",
                        loginName: "@\(response.userName)",
                        bio: response.bio)
                    
                    completion(.success(profileResult))
                } catch {
                    completion(.failure(error))
                    return
                }
                self?.task = nil// почему здесь обнуляется? потому что ассинхронный код.
            }
        }
        self.task = task
        task.resume()
    }
    
    
    
}//
