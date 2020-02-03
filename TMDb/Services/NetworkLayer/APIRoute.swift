//
//  APIRoute.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case head    = "HEAD"
    case options = "OPTIONS"
    case connect = "CONNECT"
}

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

protocol APIRoute: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var bodyParameters: Parameters? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension APIRoute {
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw HTTPError.sdkError(type: .malformedRequest)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        //urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Set parameters
        if let parameters = bodyParameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = data
            } catch {
                throw HTTPError.sdkError(type: .malformedRequest)
            }
        }
        return urlRequest
    }
}
