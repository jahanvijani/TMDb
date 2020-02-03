//
//  DetailMovieCoordinator.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import UIKit

protocol DetailMovieCoordinatorDelegate: class {
    func detailCoordinatorDidComplete()
}

class DetailMovieCoordinator: Coordinator {
    
    weak var delegate: DetailMovieCoordinatorDelegate?
    
    var navigationController: UINavigationController
    var moviesDetailViewController: MoviesDetailViewController?
    var movie: Movie
    
    init(navigationController navController: UINavigationController, selectedMovie: Movie) {
        self.navigationController = navController
        self.movie = selectedMovie
    }
    
    func start() {
        moviesDetailViewController = MoviesDetailViewController()
        
        guard let moviesDetailViewController = moviesDetailViewController else { return }
        
        let viewModel =  MovieDetailsViewModel(movieId: movie.id)
        viewModel.coordinatorDelegate = self
        moviesDetailViewController.viewModel = viewModel
        self.navigationController.pushViewController(moviesDetailViewController, animated: true)
    }
}

extension DetailMovieCoordinator: MovieDetailsViewModelCoordinatorDelegate {
    
    func dismiss() {
        delegate?.detailCoordinatorDidComplete()
    }
}
