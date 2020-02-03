//
//  MoviesViewModel.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

protocol ListMoviesBusinessLogic {
    func fetchPopularMovies()
}

protocol ListMoviesDataSource {
    var movies: [Movie] { get }
}

protocol MoviesViewModelDelegate: class {
    func onSuccess(with newIndexPathsToReload: [IndexPath]?)
    func onFailure(with error: Error)
}

protocol MoviesViewModelCoordinatorDelegate: class {
    func moviesViewModelDidSelect(_ viewModel: MoviesViewModel, selectedMovie: Movie)
}

class MoviesViewModel: ListMoviesDataSource, ListMoviesBusinessLogic {
    
    weak var viewDelegate: MoviesViewModelDelegate?
    weak var coordinatorDelegate: MoviesViewModelCoordinatorDelegate?
    
    var currentPage = 1
    var totalResults = 0
    private var isFetchInProgress = false
    
    var currentCount: Int {
        return movies.count
    }
    var fetchMoviesService: FetchMovieProtocol?
    var movies: [Movie] = []
    
    init(service: FetchMovieProtocol = FetchMovieService()) {
        self.fetchMoviesService = service
    }
    
    // MARK: - Fetch Popular Movies
    func fetchPopularMovies() {
        
        guard let fetchMoviesService = fetchMoviesService else {
            let serviceError = HTTPError.sdkError(type: .notInitialized)
            self.viewDelegate?.onFailure(with: serviceError)
            return
        }
        
        guard !isFetchInProgress else {
          return
        }
        
        isFetchInProgress = true
        print("Fetching data for page:\(currentPage)")
        fetchMoviesService.fetchMovies(page: currentPage, completionHandler: {(result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let moviesRecord):
                    self.isFetchInProgress = false
                    self.currentPage = self.currentPage + 1
                    self.totalResults = moviesRecord.total_results
                    self.movies.append(contentsOf: moviesRecord.results)

                    if moviesRecord.page > 1 {
                      let indexPathsToReload = self.calculateIndexPathsToReload(from: moviesRecord.results)
                        self.viewDelegate?.onSuccess(with: indexPathsToReload)
                    } else {
                        self.viewDelegate?.onSuccess(with: nil)
                    }
                case .failure(let error):
                    self.isFetchInProgress = false
                    self.viewDelegate?.onFailure(with: error)
                }
            }
        })
    }
    
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    // MARK: - Did Select Movie Method
    func didSelectMovie(index: Int) {
        if  index >= 0, index < currentCount {
            coordinatorDelegate?.moviesViewModelDidSelect(self, selectedMovie: movies[index])
        }
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
}
