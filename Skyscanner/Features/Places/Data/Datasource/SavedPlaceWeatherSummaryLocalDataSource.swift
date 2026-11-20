//
//  SavedPlaceWeatherSummaryLocalDataSource.swift
//  Skyscanner
//
//  Created by debmalyakar on 18/11/26.
//

import Foundation
import SwiftData

/// Fetching all PlaceWeatherSummary
protocol SavedPlaceWeatherSummaryLocalDataSource  {
    func fetchAllWeatherSummaries() async throws -> [PlaceWeatherSummary]
}

extension WeatherCacheStoreImpl : SavedPlaceWeatherSummaryLocalDataSource {
    func fetchAllWeatherSummaries() async throws -> [PlaceWeatherSummary] {
        dispatchPrecondition(condition: .notOnQueue(.main))
        let descriptor = FetchDescriptor<SavedPlace>(sortBy: [SortDescriptor(\.sortIndex)])
        return try modelContext.fetch(descriptor).map { $0.toPlaceWeatherSummary() }
    }
}
