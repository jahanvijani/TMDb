//
//  FetchMovieService+Tests.swift
//  TMDbTests
//
//  Created by Jahanvi Vyas on 03/02/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import XCTest
@testable import TMDb

class FetchMovieService_Tests: TMDbTests {

    var service: MockMovieService!
    
    override func setUp() {
        super.setUp()
        self.service = MockMovieService()
    }

    override func tearDown() {
        self.service = nil
        super.tearDown()
    }
}

extension FetchMovieService_Tests {
    
    // MARK: Success
    func testGetMoviesRecordSuccess() {
        
        var result: Result<MoviesRecord, Error>!
        let expectation = self.expectation(description: "Success")
        
        service.moviesRecord = getMockMoviesRecord()
            
        service.fetchMovies(page: 1) {
            result = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertTrue(try! result.get().results.count > 0)
    }
    
    func testGetMoviesRecordServerError() {
        
        var result: Result<MoviesRecord, Error>!
        let expectation = self.expectation(description: "Server Error")
        
        service.error = HTTPError.serverError(type: .serverError, nil)
            
        service.fetchMovies(page: 1) {
            result = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertThrowsError(try result.get(), "") { error in
            let httpError = error as? HTTPError
            if case .serverError(type: .serverError, nil) = httpError {
                XCTAssertTrue(httpError != nil)
            }
        }
    }
    
    func testGetMoviesRecordNetworkError() {
        var moviesRecord: MoviesRecord?
        var errorResponse: Error!
        let expectation = self.expectation(description: "Server Error")
        
        let networkError = NSError(domain:"TransportError", code:-1009, userInfo:nil)
        service.error = HTTPError.transportError(type: .notConnectedToInternet, networkError)
        
        service.fetchMovies(page: 1) { (result) in
            switch result {
            case .success(let record):
                moviesRecord = record
            case .failure(let error):
                errorResponse = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNil(moviesRecord)
        XCTAssertNotNil(errorResponse)
    }
}


