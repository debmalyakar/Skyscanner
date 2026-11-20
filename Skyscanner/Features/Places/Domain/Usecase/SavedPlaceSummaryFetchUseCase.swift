//
//  SavedPlaceSummaryFetchUseCase.swift
//  Skyscanner
//
//  Created by debmalyakar on 18/11/26.
//

import Foundation
protocol SavedPlaceSummaryWeatherFetchUseCase {
    func fetchAllSavedPlacesWeatherSummary() async throws -> [PlaceWeatherSummary]
}

final class SavedPlaceSummaryWeatherFetchUseCaseImpl: SavedPlaceSummaryWeatherFetchUseCase {
 
    private let savedPlaceWeatherSummaryRepo: SavedPlaceWeatherSummaryRepository
    
    init(savedPlaceWeatherSummaryRepo: SavedPlaceWeatherSummaryRepository) {
        self.savedPlaceWeatherSummaryRepo = savedPlaceWeatherSummaryRepo
    }
    
    func fetchAllSavedPlacesWeatherSummary() async throws -> [PlaceWeatherSummary] {
        try await savedPlaceWeatherSummaryRepo.fetchAllPlaceWeatherSummaries()
    }
    
}
