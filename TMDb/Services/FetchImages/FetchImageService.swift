//
//  FetchPosterImageService.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 03/02/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

var imageCache = [String: Data]()

typealias FetchImageHandler = (Result<Data, Error>) -> Void

protocol FetchImageProtocol {
    func fetchImage(imagePath: String, imageSize: ImageSize, completionHandler: @escaping FetchImageHandler)
}

class FetchImageService: FetchImageProtocol {
    
    let apiClient: APIClient
    
    init() {
        apiClient = APIClientImplementation(urlSessionConfiguration: .default, completionHandlerQueue: .main)
    }
    
    func fetchImage(imagePath: String, imageSize: ImageSize, completionHandler: @escaping FetchImageHandler) {
        
        let fetchDataReuqest = FetchImageRequest(path: imagePath, imageSize: imageSize)
        
        // First check for cached data
        if let cachedImageData = imageCache[fetchDataReuqest.path] {
            completionHandler(.success(cachedImageData))
            return
        }
    
        typealias CompletionHandler = Result<Data, Error>
        
        apiClient.execute(request: fetchDataReuqest) { (result: CompletionHandler) in
            switch result {
            case .success(let data):
                // Cache image data
                imageCache[fetchDataReuqest.path] = data
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
