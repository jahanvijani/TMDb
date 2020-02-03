//
//  FetchImageRequest.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 03/02/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

enum ImageSize: String {
    case poster = "/t/p/w185"
    case background = "/t/p/w300"
    case original = "/t/p/original"
}

struct FetchImageRequest: APIRoute, APIRequest {
    
    var imagePath: String
    var imageSize: ImageSize
    
    init(path: String, imageSize: ImageSize) {
        self.imagePath = path
        self.imageSize = imageSize
    }
    
    var baseURL: URL {
        return AppConfig.imageBaseUrl
    }
    
    var path: String {
        return imageSize.rawValue + imagePath
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
