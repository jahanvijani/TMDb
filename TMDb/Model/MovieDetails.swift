//
//  MovieDetails.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 30/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

struct MovieDetails: Codable {
    let backdrop_path: String?
    let poster_path: String?
    let title: String?
    let overview: String?
    let release_date: String?
    let runtime: Int?
}
