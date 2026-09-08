//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Алик on 26.08.2026.
//

import Foundation

enum NetworkErrorForClient: Error {
    case codeError
}

class NetworkClient {
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkErrorForClient.codeError))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()//
    }
    
}
