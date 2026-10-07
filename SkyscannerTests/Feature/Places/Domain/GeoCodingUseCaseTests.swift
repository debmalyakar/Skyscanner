//
//  GeoCodingUseCaseTests.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 30/09/26.
//

import XCTest
@testable import Skyscanner

final class GeoCodingUseCaseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    @MainActor
    func test_query_count_GeoCoding() async throws {
        
        let mockGeoCodingRepo = GeoCodingRepositoryMock(result: .success([]))
        let sut = GeocodingFetchUseCase(goecodingRepo: mockGeoCodingRepo)
        _ = try await sut.fetchGeocoding(query: "Kolkata")
        
        XCTAssertTrue(mockGeoCodingRepo.queryToCheck == "Kolkata")
        XCTAssertTrue(mockGeoCodingRepo.countToCheck == 10)

    }
    @MainActor
    func test_check_error_GeoCoding() async throws {
        let mockGeoCodingRepo = GeoCodingRepositoryMock(result: .failure(NetworkError.badResponse))
        let sut = GeocodingFetchUseCase(goecodingRepo: mockGeoCodingRepo)
        
        do {
            _ = try await sut.fetchGeocoding(query: "Kolkata")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    @MainActor
    func test_Success_GeoCoding() async throws {
        let results = [
            GeocodingResult(id: 1, name: "Kolkata", latitude: 23.44, longitude: 43.44, country: "India", admin1: "anyAdmin", timezone: "IST"),
            GeocodingResult(id: 1, name: "Bangalore", latitude: 23.45, longitude: 43.45, country: "India", admin1: "anyAdmin", timezone: "IST")
        ]
        let mockGeoCodingRepo = GeoCodingRepositoryMock(result: .success(results))
        let sut = GeocodingFetchUseCase(goecodingRepo: mockGeoCodingRepo)
        let result_Response = try await sut.fetchGeocoding(query: "Kolkata")
        XCTAssertTrue(result_Response.count == 2)
        XCTAssertTrue(results == result_Response)
    }

}
       
