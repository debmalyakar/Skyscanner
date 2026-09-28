//
//  DataSourceTests.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 27/09/26.
//

import XCTest
@testable import Skyscanner

final class PlacesDataSourceTests: XCTestCase {

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
    func test_query_items_And_Url_For_GeoCodingDatasource() async throws {
        let sut = GeoCodingMockApiClient(inputResponse: .responseModel(.success(GeocodingResponseDTO(results: []))))
        let geoCodingRemoteDataSource = GeocodingFetchRemoteDataSourceImpl(apiClient: sut)
        let _ = try await geoCodingRemoteDataSource.fetchGeocodingResults(query: "London", count: 10)
        let urlComponent = sut.urlComponents[0]
        
        XCTAssertEqual(urlComponent.queryItems!.first(where: { $0.name == "name" })?.value, "London")
        XCTAssertEqual(urlComponent.queryItems!.first(where: { $0.name == "count" })?.value, "10")
        XCTAssertEqual(urlComponent.queryItems!.first(where: { $0.name == "format" })?.value, "json")
        XCTAssertEqual(urlComponent.queryItems!.first(where: { $0.name == "language" })?.value, "en")
        XCTAssertEqual(urlComponent.string, "https://geocoding-api.open-meteo.com/v1/search?name=London&count=10&language=en&format=json")
    }
    
    @MainActor
    func test_Error_propagation_for_GeoCodingDatasource() async throws {
        let sut = GeoCodingMockApiClient(inputResponse: .responseModel(.failure(NetworkError.badResponse)))
        let geoCodingRemoteDataSource = GeocodingFetchRemoteDataSourceImpl(apiClient: sut)
        
        do {
            let _ = try await geoCodingRemoteDataSource.fetchGeocodingResults(query: "London", count: 10)
            XCTFail("should fail with bad response error")
        }
        catch let error as NetworkError {
            XCTAssert(error == NetworkError.badResponse, "Got bad response error successfully")
        } catch {
            XCTFail("should fail with bad response error")
        }
    }
    @MainActor
    func test_Response_decoding_for_GeoCodingDatasource() async throws {
        let result = [
            GeocodingResultDTO(id: 1, name: "Kolkata", latitude: 88.34, longitude: 44.34, country: "India", admin1: "", timezone: "IST"),
            GeocodingResultDTO(id: 1, name: "Bangalore", latitude: 88.34, longitude: 44.34, country: "India", admin1: "", timezone: "IST")
        ]
        let sut = GeoCodingMockApiClient(inputResponse: .responseModel(.success(GeocodingResponseDTO(results: result))))
        let geoCodingRemoteDataSource = GeocodingFetchRemoteDataSourceImpl(apiClient: sut)
        let response = try await geoCodingRemoteDataSource.fetchGeocodingResults(query: "London", count: 10)
        XCTAssertEqual(response, result)
    }
    
    
}
