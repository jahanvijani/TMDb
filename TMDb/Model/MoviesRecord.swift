//
//  Movies.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import Foundation

struct MoviesRecord: Codable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
