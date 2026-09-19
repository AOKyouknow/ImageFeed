//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Алик on 26.08.2026.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
    case noData
}

extension URLSession {
    private func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("Неверный HTTP статус-код \(statusCode) для URL: \(request)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Ошибка запроса: \(error.localizedDescription) для URL: \(request)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Неизвестная ошибка сессии для URL: \(request)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(
            for request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
        ) -> URLSessionTask {
            let decoder = JSONDecoder()
            
            let task = data(for: request) { (result: Result<Data, Error>) in
                switch result {
                case .success(let data):
                    
                    do {
                        let decodedObject = try decoder.decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        let rawJsonString = String(data: data, encoding: .utf8) ?? "Не удалось преобразовать Data в UTF-8 String"
                                           print("Ошибка декодирования: \(error.localizedDescription), Данные: \(rawJsonString)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
            return task
        }
    
}
    
    

