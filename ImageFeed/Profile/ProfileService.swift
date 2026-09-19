//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Алик on 15.09.2026.
//

import Foundation

final class ProfileService {
    private(set) var profile: Profile?
    static let shared = ProfileService()
    private init () {}
    
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
            print("[ProfileService/fetchProfile]: token is nil")
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
            print("[ProfileService/fetchProfile]: invalidRequest - токен: \(token)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(
                    username: profileResult.userName,
                    name: "\(profileResult.firstName) \(profileResult.lastName)",
                    loginName: "@\(profileResult.userName)",
                    bio: profileResult.bio
                )
                self.profile = profile
                completion(.success(profile))
                
            case .failure(let error):
                print("[ProfileService/fetchProfile]: \(error)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    
    
}//
