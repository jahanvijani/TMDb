//
//  FetchDataAPIRoute.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 30/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

struct FetchMovieRequest: APIRoute, APIRequest {
    
    var page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    var baseURL: URL {
        return AppConfig.baseUrl
    }
    
    var path: String {
        return "/3/movie/popular"
    }
    
    var httpMethod: HTTPMethod = .get
    
    var bodyParameters: Parameters? = nil
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "api_key", value: AppConfig.apiKey),
                URLQueryItem(name: "page", value: String(page))]
    }
    
    var urlRequest: URLRequest {
        let urlRequest = try! self.asURLRequest()
        return urlRequest
    }
}
