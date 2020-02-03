//
//  FetchMovieDetailsRequest.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 30/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

struct FetchMovieDetailsRequest: APIRoute, APIRequest {
    
    var movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    var baseURL: URL {
        return AppConfig.baseUrl
    }
    
    var path: String {
        return "/3/movie/\(movieId)"
    }
    
    var httpMethod: HTTPMethod = .get
    
    var bodyParameters: Parameters? = nil
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "api_key", value: AppConfig.apiKey)]
    }
    
    var urlRequest: URLRequest {
        let urlRequest = try! self.asURLRequest()
        return urlRequest
    }
}
