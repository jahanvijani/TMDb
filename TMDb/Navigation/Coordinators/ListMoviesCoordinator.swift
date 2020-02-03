//
//  ListMoviesCoordinator.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import UIKit

class ListMoviesCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var moviesListViewController: MoviesListViewController?
    var detailMovieCoordinator: DetailMovieCoordinator?
    
    init(navigationController navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        moviesListViewController = MoviesListViewController()
        
        guard let moviesListViewController = moviesListViewController else { return }
        
        let viewModel =  MoviesViewModel()
        viewModel.coordinatorDelegate = self
        moviesListViewController.viewModel = viewModel
        self.navigationController.pushViewController(moviesListViewController, animated: true)
    }
}

extension ListMoviesCoordinator: MoviesViewModelCoordinatorDelegate {
    
    func moviesViewModelDidSelect(_ viewModel: MoviesViewModel, selectedMovie: Movie) {
        // Show detail screen
        detailMovieCoordinator = DetailMovieCoordinator(navigationController: self.navigationController, selectedMovie: selectedMovie)
        detailMovieCoordinator?.delegate = self
        detailMovieCoordinator?.start()
    }
}

extension ListMoviesCoordinator: DetailMovieCoordinatorDelegate {
    
    func detailCoordinatorDidComplete() {
        self.detailMovieCoordinator = nil
    }
}
