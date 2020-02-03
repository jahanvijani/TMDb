//
//  FetchDataAPIRequest.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 30/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

typealias FetchMovieHandler = (Result<MoviesRecord, Error>) -> Void

protocol FetchMovieProtocol {
    func fetchMovies(page: Int, completionHandler: @escaping FetchMovieHandler)
}

class FetchMovieService: FetchMovieProtocol {
    
    let apiClient: APIClient
    
    init() {
        apiClient = APIClientImplementation(urlSessionConfiguration: .default, completionHandlerQueue: .main)
    }
    
    func fetchMovies(page: Int, completionHandler: @escaping FetchMovieHandler) {
        
        typealias CompletionHandler = Result<MoviesRecord, Error>
        let fetchDataReuqest = FetchMovieRequest(page: page)
        apiClient.execute(request: fetchDataReuqest) { (result: CompletionHandler) in
            switch result {
            case .success(let moviesRecord):
                completionHandler(.success(moviesRecord))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
