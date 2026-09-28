//
//  GeoCodingDTOUnitTests.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 28/09/26.
//

import XCTest
@testable import Skyscanner

final class GeoCodingDTOUnitTests: XCTestCase {

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
    func test_Geocoding_success_Response() async throws {
        let geoCodingSuccessJSONData = JsonLoader.loadJson(from: "GeocodingSuccessResponse")
        let mockUrlSession = MockUrlSession.success(statusCode: 200 , data: geoCodingSuccessJSONData)
        let geoCodingApiClient = GeocodingAPIClient(urlSession: mockUrlSession)
        let sut = GeocodingFetchRemoteDataSourceImpl(apiClient: geoCodingApiClient)
        let resultsArr = try await sut.fetchGeocodingResults(query: "Lisbon", count: 10)
//        let result = try await geoCodingApiClient.getResponse(from: URLComponents())
//        let resultsArr = result.results ?? []
        XCTAssertEqual(resultsArr.count, 10)
        let geoCodingObject = resultsArr[0]
        XCTAssertEqual(geoCodingObject.name, "Lisbon")
        XCTAssertEqual(geoCodingObject.country, "Portugal")
        XCTAssertEqual(geoCodingObject.latitude, 38.72509)
        XCTAssertEqual(geoCodingObject.longitude, -9.1498)
    }
    @MainActor
    func test_Geocoding_Empty_Response() async throws {
        let geoCodingSuccessJSONData = JsonLoader.loadJson(from: "GeoCodingEmptyResponse")
        let mockUrlSession = MockUrlSession.success(statusCode: 200 , data: geoCodingSuccessJSONData)
        let geoCodingApiClient = GeocodingAPIClient(urlSession: mockUrlSession)
//        let result = try await geoCodingApiClient.getResponse(from: URLComponents())
        let sut = GeocodingFetchRemoteDataSourceImpl(apiClient: geoCodingApiClient)
        let resultsArr = try await sut.fetchGeocodingResults(query: "Lisbon", count: 10)
        XCTAssertEqual(resultsArr.count, 0)
        
    }
    @MainActor
    func test_Geocoding_Error_Response() async throws {
        let mockUrlSession = MockUrlSession.failure(NetworkError.badResponse)
        let geoCodingApiClient = GeocodingAPIClient(urlSession: mockUrlSession)
        let sut = GeocodingFetchRemoteDataSourceImpl(apiClient: geoCodingApiClient)
        do {
            let resultsArr = try await sut.fetchGeocodingResults(query: "Lisbon", count: 10)
            XCTFail()
        }catch let error as NetworkError {
            XCTAssertEqual(error, .badResponse)
        }catch {
            XCTFail()
        }
    }
    
}
