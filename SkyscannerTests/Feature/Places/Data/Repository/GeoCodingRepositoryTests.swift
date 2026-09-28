//
//  GeoCodingRepositoryTests.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 29/09/26.
//

import XCTest
@testable import Skyscanner

final class GeoCodingRepositoryTests: XCTestCase {

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
    func test_Success_GeoCoding_Remote_DataSource() async throws {
        let results = [
            GeocodingResultDTO(id: 1, name: "Kolkata", latitude: 22.33, longitude: 88.64, country: "India", admin1: "anyadmin", timezone: "IST"),
            GeocodingResultDTO(id: 1, name: "Bangalore", latitude: 23.33, longitude: 89.64, country: "India", admin1: "anyadmin", timezone: "IST")
        ]
        let geoCodingRemoteDataSourceMock = GeoCodingRemoteDataSourceMock.success(with: results)
        let sut = GeocodingRepositoryImpl(dataSource: geoCodingRemoteDataSourceMock)
        let response = try await sut.fetchGeocodingResults(query: "Kolkata", count: 10)
        XCTAssertEqual(response.count, 2)
        XCTAssertEqual(response.first?.name, "Kolkata")
        XCTAssertEqual(response.first?.latitude, 22.33)
        XCTAssertEqual(response.first?.longitude, 88.64)
        XCTAssertEqual(response.first?.country, "India")
        XCTAssertEqual(response.first?.admin1, "anyadmin")
        XCTAssertEqual(response.first?.timezone, "IST")
        
        XCTAssertEqual(response[1].name, "Bangalore")
        XCTAssertEqual(response[1].latitude, 23.33)
        XCTAssertEqual(response[1].longitude, 89.64)
        XCTAssertEqual(response[1].country, "India")
        XCTAssertEqual(response[1].admin1, "anyadmin")
        XCTAssertEqual(response[1].timezone, "IST")
        
    }
    
    @MainActor
    func test_function_parameters() async throws {
        let geoCodingRemoteDataSourceMock = GeoCodingRemoteDataSourceMock.success(with: [])
        let sut = GeocodingRepositoryImpl(dataSource: geoCodingRemoteDataSourceMock)
        let _ = try await sut.fetchGeocodingResults(query: "Kolkata", count: 10)
        XCTAssertEqual(geoCodingRemoteDataSourceMock.queryToCheck, "Kolkata")
        XCTAssertEqual(geoCodingRemoteDataSourceMock.countToCheckInQuery, 10)
    }

    @MainActor
    func test_failure_condition() async throws {
        let geoCodingRemoteDataSourceMock = GeoCodingRemoteDataSourceMock.failure(with: NetworkError.badResponse)
        let sut = GeocodingRepositoryImpl(dataSource: geoCodingRemoteDataSourceMock)
        do {
            let _ = try await sut.fetchGeocodingResults(query: "Kolkata", count: 10)
            XCTFail("should throw an error")
        }catch let error as NetworkError {
            XCTAssertEqual(error, .badResponse)
        }catch {
            XCTFail("should throw a bad response error")
        }
    }
    @MainActor
    func test_no_query_Matches_Found() async throws {
        let geoCodingRemoteDataSourceMock = GeoCodingRemoteDataSourceMock.success(with: [])
        let sut = GeocodingRepositoryImpl(dataSource: geoCodingRemoteDataSourceMock)
        let result = try await sut.fetchGeocodingResults(query: "Kolkata", count: 10)
        XCTAssertEqual(result.isEmpty,true)
    }

}
