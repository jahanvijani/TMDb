//
//  APIClient.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

typealias CompletionHandler<T:Decodable> = (Result<T, Error>) -> Void

protocol APIRequest {
    var urlRequest: URLRequest { get }
}

protocol APIClient {
    func execute<T>(request: APIRequest, completion: @escaping CompletionHandler<T>) -> Void
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }


class APIClientImplementation: APIClient {
    
    let urlSession: URLSessionProtocol
    
    init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
    }
    
    // This should be used mainly for testing purposes
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    //MARK: - ApiClient
    func execute<T>(request: APIRequest, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
        let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
            
            if let error = error {
                self.handleTransportError(error: error, completion: completion)
                return
            }
            
            let response = response as! HTTPURLResponse
            if (200...299).contains(response.statusCode) {
                self.handleSuccess(data: data, response: response, completion: completion)
                return
            }
            
            self.handleServerError(data: data, response: response, completion: completion)
        }
        dataTask.resume()
    }
    
    
    //MARK: - Handle Success
    private func handleSuccess<T: Decodable>(data: Data?, response: HTTPURLResponse?, completion: CompletionHandler<T>) {
        
        if data is T {
            // If response type is Data, return data
            if let data = data {
                completion(Result.success(data as! T))
            }
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data ?? Data())
            completion(Result.success(decoded))
        } catch {
            // Parse error
            let error = HTTPError.serverError(type: .responseDecodingError, response!)
            completion(.failure(error))
        }
    }
    
    //MARK: - Handle Transport Error
    private func handleTransportError<T: Decodable>(error: Error, completion: CompletionHandler<T>) {
        guard let transportError = TransportError(rawValue: (error as NSError).code) else {
            let transportError = HTTPError.transportError(type: .unknown, error)
            completion(.failure(transportError))
            return
        }
        
        completion(.failure(HTTPError.transportError(type: transportError, error)))
    }
    
    //MARK: - Handle Server Error
    private func handleServerError<T: Decodable>(data: Data?, response: HTTPURLResponse?, completion: CompletionHandler<T>) {
        
        if let statusCode = response?.statusCode,
            let error = ServerError(rawValue: statusCode) {
            completion(.failure(error))
        }
        let error = HTTPError.serverError(type: .unknown, response)
        completion(.failure(error))
    }
}
