//
//  MoviesListViewController.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {

    private var tableView = UITableView()
    private var loading = UIActivityIndicatorView(style: .large)
    
    var viewModel: MoviesViewModel? {
        didSet {
            self.loading.startAnimating()
            viewModel?.viewDelegate = self
            viewModel?.fetchPopularMovies()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "tmdb_title".localized()
        setupTableView()
        setupLoading()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.separatorColor = .gray
        tableView.backgroundColor = TMDbStyle.ColorPalette.primaryColor
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    private func setupLoading() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        view.addSubview(loading)

        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - MoviesViewModelDelegate Delegate
extension MoviesListViewController: MoviesViewModelDelegate {
    
    func onSuccess(with newIndexPathsToReload: [IndexPath]?) {
        self.loading.stopAnimating()
        guard let newIndexPathsToReload = newIndexPathsToReload else {
          self.tableView.reloadData()
          return
        }
        
        let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFailure(with error: Error) {
        self.loading.stopAnimating()
        self.displayError(error: error)
    }
    
    private func displayError(error: Error) {
        let alert = UIAlertController(title: "TMdb", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableView Data Source
extension MoviesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalResults ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.showLoading()
        } else {
            let movie = viewModel?.movies[indexPath.row]
            cell.showDetails(movie: movie, viewModel: viewModel)
        }
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectMovie(index: indexPath.row)
    }
}

// MARK: - UITableView Data Source Prefetching
extension MoviesListViewController: UITableViewDataSourcePrefetching {
    
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
    if indexPaths.contains(where: isLoadingCell) {
        viewModel?.fetchPopularMovies()
    }
  }
}

// MARK: - UITableView Prefech Logic
extension MoviesListViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        guard let viewModel = viewModel else { return false }
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
