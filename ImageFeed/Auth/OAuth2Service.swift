//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Алик on 24.08.2026.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "client_id=\(Constants.accessKey)&client_secret=\(Constants.secretKey)&redirect_uri=\(Constants.redirectURI)&code=\(code)&grant_type=authorization_code"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                let token = response.accessToken
                OAuth2TokenStorage.shared.token = token
                completion(.success(token))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }
        task.resume()
    }
    
    
}
