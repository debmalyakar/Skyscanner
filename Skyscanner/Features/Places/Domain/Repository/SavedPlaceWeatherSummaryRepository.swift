//
//  SavedPlaceWeatherSummaryRepository.swift
//  Skyscanner
//
//  Created by debmalyakar on 18/11/26.
//

import Foundation
protocol SavedPlaceWeatherSummaryRepository {
    func fetchAllPlaceWeatherSummaries() async throws -> [PlaceWeatherSummary]
}
