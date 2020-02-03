//
//  Movie.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let popularity: Float
    let vote_count: Int
    let video: Bool
    let poster_path: String?
    let id: Int
    let adult: Bool
    let backdrop_path: String?
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let title: String
    let vote_average: Float
    let overview: String
    let release_date: String?
}
