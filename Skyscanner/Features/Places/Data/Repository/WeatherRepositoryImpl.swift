//
//  WeatherRepositoryImpl.swift
//  Skyscanner
//
//  Created by debmalyakar on 06/11/26.
//

import Foundation

enum WeatherDataError: Error {
    /// Open-Meteo returned a different number of results than places requested,
    /// so results can't be safely matched to places.
    case resultCountMismatch(expected: Int, got: Int)
}

final class WeatherRepositoryImpl: WeatherRepository {
    private let remote: WeatherFetchRemoteDataSource
    private let local: WeatherLocalDataSource
    private let batchSize: Int
 
    init(remote: WeatherFetchRemoteDataSource,
         local: WeatherLocalDataSource,
         batchSize: Int = 10) {
        self.remote = remote
        self.local = local
        self.batchSize = batchSize
    }
 
    @concurrent func fetchWeatherData(for coordinates: [PlaceCoordinate]) async throws {
        guard !coordinates.isEmpty else { return }
 
        for start in stride(from: 0, to: coordinates.count, by: batchSize) {
            let batch = Array(coordinates[start ..< min(start + batchSize, coordinates.count)])
 
            // The network call suspends; the main actor is free while it waits,
            // and decoding runs off-main via ApiClient's @concurrent decode.
            let response: [ForecastResponseDTO] = try await remote.fetchWeather(
                latitudes: batch.map(\.latitude),
                longitudes: batch.map(\.longitude)
            )
 
            // Results come back in request order. If the count is off, matching
            // by position could put one city's weather on another, so stop.
            guard response.count == batch.count else {
                throw WeatherDataError.resultCountMismatch(expected: batch.count, got: response.count)
            }
 
            try await local.replaceWeather(Array(zip(batch, response)))
        }
    }
}
