//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Алик on 24.08.2026.
//

import Foundation

final class OAuth2Service {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        }
        
        
        lastCode = code
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                
                if let error {
                    completion(.failure(error))
                }
                
                guard let httpResponse =
                        response as? HTTPURLResponse,
                      (Constants.httpResponseMinCode..<Constants.httpResponseMaxCode).contains(httpResponse.statusCode)
                else {
                    completion(.failure(NetworkError.urlSessionError))
                    return
                }
                
                guard let data else {
                    completion(.failure(NetworkError.urlSessionError))
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
                
                self?.task = nil
                self?.lastCode = nil
                
            }
        }
        
        //    static let shared = OAuth2Service()
        //
        //    private init() {}
        //
        //    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        //        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
        //            completion(.failure(NetworkError.invalidRequest))
        //            return
        //        }
        //
        //        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        //
        //            if let error = error {
        //                DispatchQueue.main.async {
        //                    completion(.failure(error))
        //                }
        //            }
        //
        //            guard let data = data else {
        //                DispatchQueue.main.async {
        //                    completion(.failure(NetworkError.urlSessionError))
        //                }
        //                return
        //            }
        //
        //            guard let httpResponse = response as? HTTPURLResponse,
        //                  (Constants.httpResponseMinCode..<Constants.httpResponseMaxCode).contains(httpResponse.statusCode) else {
        //                DispatchQueue.main.async {
        //                    completion(.failure(NetworkError.urlSessionError))
        //                }
        //                return
        //            }
        //            do {
        //                let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
        //                let token = response.accessToken
        //                OAuth2TokenStorage.shared.token = token
        //                DispatchQueue.main.async {
        //                    completion(.success(token))
        //                }
        //            } catch {
        //                DispatchQueue.main.async {
        //                    completion(.failure(NetworkError.decodingError(error)))
        //                }
        //            }
        //        }
        self.task = task
        task.resume()
    }//fetchOAuthToken
    
    //    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
    //        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
    //            return nil
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //
    //        let body = "client_id=\(Constants.accessKey)&client_secret=\(Constants.secretKey)&redirect_uri=\(Constants.redirectURI)&code=\(code)&grant_type=authorization_code"
    //        request.httpBody = body.data(using: .utf8)
    //
    //        return request
    //    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {  // 18
        guard
            var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
    
    
}
