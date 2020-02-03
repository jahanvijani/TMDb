//
//  MoviesDetailViewController.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 30/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var releaseDateLabel = UILabel()
    var durationLabel = UILabel()
    var overviewLabel = UILabel()
    var separator = UIView()
    
    private var loading = UIActivityIndicatorView(style: .large)
    
    var viewModel: MovieDetailsViewModel? {
        didSet {
            self.loading.startAnimating()
            viewModel?.viewDelegate = self
            viewModel?.fetchMovieDetails()
        }
    }
    
    var topBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0.0
        
        if #available(iOS 13, *) {
            statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        
        return statusBarHeight + navigationBarHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        setupLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            viewModel?.dismissMovieDetailCoorinator()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = TMDbStyle.ColorPalette.primaryColor
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = TMDbStyle.ColorPalette.secondaryColor
        titleLabel.font = TMDbStyle.Font.titleFont
        scrollView.addSubview(titleLabel)
        
        releaseDateLabel.numberOfLines = 0
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.textColor = .lightGray
        releaseDateLabel.textAlignment = .right
        releaseDateLabel.font = TMDbStyle.Font.contentFont
        scrollView.addSubview(releaseDateLabel)
        
        durationLabel.numberOfLines = 0
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.textColor = .lightGray
        durationLabel.font = TMDbStyle.Font.contentFont
        scrollView.addSubview(durationLabel)
        
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.textColor = .lightGray
        overviewLabel.font = TMDbStyle.Font.contentFont
        scrollView.addSubview(overviewLabel)
        
        separator.backgroundColor = .darkGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(separator)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10.0
        let topMargin = topBarHeight + padding
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topMargin),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            
            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            durationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            durationLabel.widthAnchor.constraint(equalToConstant: 100),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            releaseDateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            releaseDateLabel.widthAnchor.constraint(equalToConstant: 200),
            
            separator.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: padding),
            separator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            separator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            separator.heightAnchor.constraint(equalToConstant: 2),
            
            overviewLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: padding),
            overviewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            overviewLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            overviewLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding)
            
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

// MARK: - MovieDetailsViewModelDelegate Delegate
extension MoviesDetailViewController: MovieDetailsViewModelDelegate {

    func onSuccess(with movieDetails: MovieDetails?) {
        self.loading.stopAnimating()
        
        guard let movieDetails = movieDetails else { return }
        
        self.titleLabel.text = movieDetails.title
        self.releaseDateLabel.text = movieDetails.release_date
        self.overviewLabel.text = movieDetails.overview
        if let movieDuration = movieDetails.runtime {
            self.durationLabel.text = "\(movieDuration) mins"
        }
        // Show loading
        if let imagePath = movieDetails.poster_path {
            viewModel?.fetchImageData(path: imagePath, completion: { [weak self] (data) in
                // Stop loading
                DispatchQueue.main.async {
                    if let data = data {
                        self?.imageView.image = UIImage(data: data)
                    }
                }
            })
        }
    }
    
    func onFailure(with error: Error) {
        self.loading.stopAnimating()
    }
}
