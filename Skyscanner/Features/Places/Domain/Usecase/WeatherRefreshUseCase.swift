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

final class WeatherRefreshUseCaseImpl: WeatherRefreshUseCase {
    private let placesRepo: SavedPlaceRepository
    private let weatherRepo: WeatherRepository
    private let maxAge: TimeInterval

    /// The refresh currently running, if any, and whether it covers every place.
    private var inFlight: (task: Task<Void, Error>, isForced: Bool)?

    init(placesRepo: SavedPlaceRepository,
         weatherRepo: WeatherRepository,
         maxAge: TimeInterval = 15 * 60) {
        self.placesRepo = placesRepo
        self.weatherRepo = weatherRepo
        self.maxAge = maxAge
    }

    /// Refreshes every saved place whose weather is missing or older than `maxAge`.
    /// `force: true` (pull-to-refresh) refreshes all of them regardless.
    /// Calls made while a refresh is running join it when it covers what they asked for.
    func refreshAll(force: Bool = false) async throws {
        if let inFlight {
            // join only if the running refresh covers this request.
            if inFlight.isForced || !force {
                return try await inFlight.task.value
            }
            // Forced call during a stale-only refresh: let it finish, then go again.
            _ = try? await inFlight.task.value
            return try await refreshAll(force: true)
        }

        let task = Task {
            // cleared by the task itself, before any waiting caller resumes.
            defer { self.inFlight = nil }
            let due = try await duePlaces(force: force)
            try await weatherRepo.fetchWeatherData(for: due)
        }
        inFlight = (task, force)
        try await task.value
    }

    /// Refreshes one place immediately, e.g. right after the user adds it.
    func refresh(_ place: PlaceCoordinate) async throws {
        try await weatherRepo.fetchWeatherData(for: [place])
    }

    private func duePlaces(force: Bool) async throws -> [PlaceCoordinate] {
        let all = try await placesRepo.getAllSavedPlaces()
        guard !force else { return all }
        let now = Date()
        return all.filter { place in
            guard let fetchedAt = place.weatherFetchedAt else { return true }
            return now.timeIntervalSince(fetchedAt) >= maxAge
        }
    }
}
