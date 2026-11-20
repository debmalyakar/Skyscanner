//
//  WeatherSummaryUseCaseMock.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 20/11/26.
//

import Foundation
@testable import Skyscanner

final class WeatherSummaryUseCaseMock : SavedPlaceSummaryWeatherFetchUseCase {
    var numberOfCalls : Int = 0
    var result : Result<[PlaceWeatherSummary] , NetworkError>
    
    init(result: Result<[PlaceWeatherSummary], NetworkError>) {
        self.result = result
    }
    func fetchAllSavedPlacesWeatherSummary() async throws -> [PlaceWeatherSummary] {
        numberOfCalls = numberOfCalls + 1
        
        switch result {
        case .success(let summaries):
            return summaries
        case .failure(let error):
            throw error
        }
    }
}
