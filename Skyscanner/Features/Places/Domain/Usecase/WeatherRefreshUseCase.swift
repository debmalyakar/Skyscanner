//
//  WeatherRefreshUseCase.swift
//  Skyscanner
//
//  Created by debmalyakar on 02/11/26.
//

import Foundation

protocol WeatherRefreshUseCase {
    func refreshAll(force: Bool) async throws
    func refresh(_ place: PlaceCoordinate) async throws
}

final class WeatherRefreshUseCaseImpl : WeatherRefreshUseCase {
    private let placesRepo : SavedPlaceRepository
    private let weatherRepo: WeatherRepository
    private let maxAge: TimeInterval
    private var task : Task<Void , Error>?
    
    init(placesRepo: SavedPlaceRepository,
         weatherRepo: WeatherRepository,
         maxAge: TimeInterval = 10 * 60) {
        self.placesRepo = placesRepo
        self.weatherRepo = weatherRepo
        self.maxAge = maxAge
    }
    
    
    /// Refreshes every saved place whose weather is missing or older than `maxAge`.
    /// `force: true` (pull-to-refresh) refreshes all of them regardless.
    /// Calls made while a refresh is running join it instead of starting another.
    func refreshAll(force: Bool = false) async throws {
        if let task { return try await task.value }
 
        let task = Task { [placesRepo, weatherRepo, maxAge] in
            let all = try await placesRepo.getAllSavedPlaces()
            let now = Date()
            let due = force ? all : all.filter { place in
                guard let fetched = place.weatherFetchedAt else { return true }
                return now.timeIntervalSince(fetched) >= maxAge
            }
            try await weatherRepo.fetchWeatherData(for: due)
        }
 
        self.task = task
        defer { self.task = nil }
        try await task.value
    }

    /// Refreshes one place immediately, e.g. right after the user adds it.
     func refresh(_ place: PlaceCoordinate) async throws {
         try await weatherRepo.fetchWeatherData(for: [place])
     }
    
}
