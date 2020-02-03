//
//  TMDbTests.swift
//  TMDbTests
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import XCTest
@testable import TMDb

class TMDbTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func getMockMoviesRecord() -> MoviesRecord? {
        let bundle = Bundle(for: type(of: self))
        if
            let fileUrl = bundle.url(forResource: "MockData", withExtension: "json"),
            let data = try? Data(contentsOf: fileUrl),
            let moviesRecord = try? JSONDecoder().decode(MoviesRecord.self, from: data) {
            return moviesRecord
        }
        return nil
    }
}
