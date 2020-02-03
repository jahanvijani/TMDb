//
//  MockMovieService.swift
//  TMDbTests
//
//  Created by Jahanvi Vyas on 03/02/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation
@testable import TMDb

class MockMovieService: FetchMovieProtocol {
    
    var moviesRecord: MoviesRecord?
    var error: Error?
    
    func fetchMovies(page: Int, completionHandler: @escaping FetchMovieHandler) {
        if let moviesRecord = moviesRecord {
            completionHandler(.success(moviesRecord))
        } else if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.failure(HTTPError.serverError(type: .unknown, nil)))
        }
    }
}
