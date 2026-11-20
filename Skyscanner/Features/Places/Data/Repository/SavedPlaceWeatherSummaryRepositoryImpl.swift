//
//  SavedPlaceWeatherSummaryRepositoryImpl.swift
//  Skyscanner
//
//  Created by debmalyakar on 18/11/26.
//

import Foundation

nonisolated final class SavedPlaceWeatherSummaryRepositoryImpl<DataSource : SavedPlaceWeatherSummaryLocalDataSource>: SavedPlaceWeatherSummaryRepository {
    private let savePlaceWeatherSummaryDataSource : DataSource
    
    init(savePlaceWeatherSummaryDataSource: DataSource) {
        self.savePlaceWeatherSummaryDataSource = savePlaceWeatherSummaryDataSource
    }
    
   @concurrent func fetchAllPlaceWeatherSummaries() async throws -> [PlaceWeatherSummary] {
       return try await savePlaceWeatherSummaryDataSource.fetchAllWeatherSummaries()
    }
}
