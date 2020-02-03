//
//  FetchMovieDetailsService.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 30/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

typealias FetchMovieDetailsHandler = (Result<MovieDetails, Error>) -> Void

protocol FetchMovieDetailsProtocol {
    func fetchMovieDetails(movieId: Int, completionHandler: @escaping FetchMovieDetailsHandler)
}

class FetchMovieDetailsService: FetchMovieDetailsProtocol {
    
    let apiClient: APIClient
    
    init() {
        apiClient = APIClientImplementation(urlSessionConfiguration: .default, completionHandlerQueue: .main)
    }
    
    func fetchMovieDetails(movieId: Int, completionHandler: @escaping FetchMovieDetailsHandler) {
        
        typealias CompletionHandler = Result<MovieDetails, Error>
        let fetchDataReuqest = FetchMovieDetailsRequest(movieId: movieId)
        apiClient.execute(request: fetchDataReuqest) { (result: CompletionHandler) in
            switch result {
            case .success(let movieDetails):
                completionHandler(.success(movieDetails))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
