//
//  MovieDetailsViewModel.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 30/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

protocol MovieDetailsBusinessLogic {
    func fetchMovieDetails()
}

protocol MovieDetailsDataSource {
    var movieDetails: MovieDetails? { get }
}

protocol MovieDetailsViewModelDelegate: class {
    func onSuccess(with movieDetails: MovieDetails?)
    func onFailure(with error: Error)
}

protocol MovieDetailsViewModelCoordinatorDelegate: class {
    func dismiss()
}

class MovieDetailsViewModel: MovieDetailsBusinessLogic {
    
    var movieId: Int
    var fetchMovieDetailsService: FetchMovieDetailsProtocol?
    
    weak var viewDelegate: MovieDetailsViewModelDelegate?
    weak var coordinatorDelegate: MovieDetailsViewModelCoordinatorDelegate?
    
    init(service: FetchMovieDetailsProtocol = FetchMovieDetailsService(), movieId: Int) {
        self.fetchMovieDetailsService = service
        self.movieId = movieId
    }
    
    func fetchMovieDetails() {
        fetchMovieDetailsService?.fetchMovieDetails(movieId: movieId, completionHandler: { (result) in
            
            switch result {
            case .success(let movieDetails):
                self.viewDelegate?.onSuccess(with: movieDetails)
            case .failure(let error):
                self.viewDelegate?.onFailure(with: error)
            }
        })
    }
    
    // MARK: - Download Image
    func fetchImageData(path: String, completion: @escaping  (Data?) -> Void) {
        let fetchImageService = FetchImageService()
        fetchImageService.fetchImage(imagePath: path, imageSize: .poster) { (result) in
            switch result {
            case .success(let imageData):
                completion(imageData)
            default:
                completion(nil)
            }
        }
    }
    
    // MARK: - Dismiss Coordinator
    func dismissMovieDetailCoorinator() {
        coordinatorDelegate?.dismiss()
    }
}
