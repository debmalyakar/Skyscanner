//
//  PlacesViewModelTests.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 14/10/26.
//

import XCTest
@testable import Skyscanner

final class PlacesViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    @MainActor
    func test_search_Idle_when_empty_query() async throws {
        let sut = makeSUT( debounceMilliSeconds: 0)
        await sut.fetchGeocodingResponse(query: "")
        XCTAssertEqual(sut.searchState, .idle)
    }
    
    func test_trimming_whitespace_from_query() async throws {
        let mockGeoCodingUseCase = GeoCodingUseCaseMock()
        let sut = makeSUT(mock: mockGeoCodingUseCase , debounceMilliSeconds: 0)
        let task = Task{ await sut.fetchGeocodingResponse(query: "   Kolkata   " , debounce: false) }
        try await mockGeoCodingUseCase.waitUntilCallStarts()
        mockGeoCodingUseCase.resume(with: .success(sampleResultsGeoCoding))
        await task.value
        XCTAssertEqual(mockGeoCodingUseCase.capturedQueries.first!, "Kolkata" , "Query passed to the use case should be trimmed")
    }
    @MainActor
    func test_Loading_State_from_Idle() async throws {
        let mockGeoCodingUseCase = GeoCodingUseCaseMock()
        let sut = makeSUT(mock: mockGeoCodingUseCase , debounceMilliSeconds: 0)
        let task = Task{ await sut.fetchGeocodingResponse(query: "Kolkata" , debounce: false) }
        try await mockGeoCodingUseCase.waitUntilCallStarts()
        XCTAssertEqual(sut.searchState, .loading)
        mockGeoCodingUseCase.resume(with: .success(sampleResultsGeoCoding))
        await task.value
    }
    @MainActor
    func test_fetch_setsLoadingState_whenStartingFromFailed() async throws {
        let mockGeoCodingUseCase = GeoCodingUseCaseMock()
        let sut = makeSUT(mock: mockGeoCodingUseCase , debounceMilliSeconds: 0)
        sut.searchState = .failed("Error text")
        let task = Task{ await sut.fetchGeocodingResponse(query: "Kolkata" , debounce: false) }
        try await mockGeoCodingUseCase.waitUntilCallStarts()
        XCTAssertEqual(sut.searchState, .loading)
        mockGeoCodingUseCase.resume(with: .success(sampleResultsGeoCoding))
        await task.value
    }
    @MainActor
    func test_sets_PreviousResult_instead_Of_Loading() async throws {
        let mockGeoCodingUseCase = GeoCodingUseCaseMock()
        let sut = makeSUT(mock: mockGeoCodingUseCase , debounceMilliSeconds: 0)
        sut.searchState = .results(sampleResultsGeoCoding)
        let task = Task{ await sut.fetchGeocodingResponse(query: "Kolkata" , debounce: false) }
        try await mockGeoCodingUseCase.waitUntilCallStarts()
        XCTAssertEqual(sut.searchState, .results(sampleResultsGeoCoding))
        mockGeoCodingUseCase.resume(with: .success(sampleResultsGeoCoding))
        await task.value
    }
    
    //MARK: -  Success Paths
    @MainActor
    func test_Success_Path_Where_Search_State_is_Results() async throws {
        let mockGeoCodingUseCase = GeoCodingUseCaseMock()
        let sut = makeSUT(mock: mockGeoCodingUseCase , debounceMilliSeconds: 0)
        let task = Task{ await sut.fetchGeocodingResponse(query: "Kolkata" , debounce: false) }
        try await mockGeoCodingUseCase.waitUntilCallStarts()
        mockGeoCodingUseCase.resume(with: .success(sampleResultsGeoCoding))

        await task.value
        
        XCTAssertEqual(sut.searchState, .results(sampleResultsGeoCoding))
    }
    @MainActor
    func test_fetch_setsEmptyState_whenUseCaseReturnsNoResults() async throws {
        let mockGeoCodingUseCase = GeoCodingUseCaseMock()
        let sut = makeSUT(mock: mockGeoCodingUseCase , debounceMilliSeconds: 0)
        let task = Task{ await sut.fetchGeocodingResponse(query: "Kolkata" , debounce: false) }
        try await mockGeoCodingUseCase.waitUntilCallStarts()
        mockGeoCodingUseCase.resume(with: .success([]))
        await task.value
        XCTAssertEqual(sut.searchState, .empty)
    }
    
    //MARK: - Failure Path
    @MainActor
    func test_check_Failure_State_When_Fetch_Fails() async throws {
        let mockGeoCodingUseCase = GeoCodingUseCaseMock()
        let sut = makeSUT(mock: mockGeoCodingUseCase , debounceMilliSeconds: 0)
        let task = Task{ await sut.fetchGeocodingResponse(query: "Kolkata" , debounce: false) }
        try await mockGeoCodingUseCase.waitUntilCallStarts()
        mockGeoCodingUseCase.resume(with: .failure(NetworkError.badResponse))
        await task.value
        XCTAssertEqual(sut.searchState, .failed("Failed to Load !"))
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

}

extension PlacesViewModelTests {
    func makeSUT(mock : GeocodingFetchUseCase = GeoCodingUseCaseMock() ,debounceMilliSeconds : UInt64 , mockPlacesSelectionUseCase : PlacesSelectionUseCase = PlaceSelectionUseCaseMock()) -> PlacesViewModel {
        let sut = PlacesViewModel(geocodingFetchUseCase: mock, placesSelectionUseCase: mockPlacesSelectionUseCase, debounceMilliSeconds: debounceMilliSeconds)
        return sut
    }
    
    var sampleResultsGeoCoding : [GeocodingResult] { [GeocodingResult(id: 1, name: "Kolkata", region: "West Bengal", subregion: "", country: "India", countryCode: "IST", latitude: 88.24, longitude: 33.32, timeZoneID: "IST", elevation: 20.0)] }
}
