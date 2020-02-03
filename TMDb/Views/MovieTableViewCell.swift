//
//  MovieCollectionViewCell.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//
import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private let padding: CGFloat = 10
    private var loading = UIActivityIndicatorView(style: .large)
    
    private let posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = TMDbStyle.ColorPalette.secondaryColor
        label.font = TMDbStyle.Font.titleFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = TMDbStyle.Font.contentFont
        label.textAlignment = .left
        return label
    }()
    
    private let votingAverageLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = TMDbStyle.Font.contentFont
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .blue
        accessoryView = UIImageView(image: UIImage(named: "arrow"))
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.color = TMDbStyle.ColorPalette.secondaryColor
        loading.hidesWhenStopped = true
        
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(releaseDateLabel)
        addSubview(votingAverageLabel)
        addSubview(loading)
        
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            posterImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: padding),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            releaseDateLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: padding),
            releaseDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding),
            
            votingAverageLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: padding),
            votingAverageLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: padding),
            votingAverageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding),
            
            self.bottomAnchor.constraint(greaterThanOrEqualTo: votingAverageLabel.bottomAnchor, constant: padding),
            self.bottomAnchor.constraint(greaterThanOrEqualTo: posterImageView.bottomAnchor, constant: padding)

        ])
    }
    
    // MARK: - clear cell data
    func showLoading() {
        loading.startAnimating()
        titleLabel.text = ""
        releaseDateLabel.text = ""
        votingAverageLabel.text = ""
        posterImageView.image = nil
    }
  
    // MARK: - show cell details
    func showDetails(movie: Movie?, viewModel: MoviesViewModel?) {
        loading.stopAnimating()
        titleLabel.text = movie?.title
        releaseDateLabel.text = movie?.release_date
        votingAverageLabel.setVoteAverage(movie?.vote_average.description)

        if let posterPath = movie?.poster_path {
            viewModel?.fetchImageData(path: posterPath, completion: {[weak self] (data) in
                if let data = data {
                    self?.posterImageView.image = UIImage(data: data)
                }
            })
        }
    }
}
