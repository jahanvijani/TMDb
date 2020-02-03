//
//  MoviesViewModel+Tests.swift
//  TMDbTests
//
//  Created by Jahanvi Vyas on 03/02/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import XCTest
@testable import TMDb

class MoviesViewModel_Tests: TMDbTests {

    var viewModel: MoviesViewModel!
    fileprivate var service: MockMovieService!
    var currentExpectaion: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        self.service = MockMovieService()
        self.viewModel = MoviesViewModel(service: service)
    }

    override func tearDown() {
        self.service = nil
        self.viewModel = nil
        super.tearDown()
    }
}

extension MoviesViewModel_Tests {
    
    // MARK: Success
    func testGetMoviesRecordSuccess() {
        currentExpectaion = self.expectation(description: "Success")
        
        // giving a service mock movies
        service.moviesRecord = getMockMoviesRecord()
       
        viewModel.viewDelegate = self
        viewModel.fetchPopularMovies()
        
        waitForExpectations(timeout: 5) { _ in
            self.viewModel.viewDelegate = nil
        }
    
        XCTAssertTrue(viewModel.movies.count > 0)
    }
    
    // MARK: No Service
    func testGetMoviesRecordWithNoService() {
        currentExpectaion = self.expectation(description: "Service Error")
        
        // giving no service to a view model
        viewModel.fetchMoviesService = nil
            
        viewModel.viewDelegate = self
        viewModel.fetchPopularMovies()
        
        waitForExpectations(timeout: 5) { _ in
            self.viewModel.viewDelegate = nil
        }
        
        XCTAssertTrue(viewModel.movies.count == 0)
    }
}


extension MoviesViewModel_Tests: MoviesViewModelDelegate {
    
    func onSuccess(with newIndexPathsToReload: [IndexPath]?) {
        currentExpectaion?.fulfill()
    }
    
    func onFailure(with error: Error) {
        currentExpectaion?.fulfill()
    }
}

