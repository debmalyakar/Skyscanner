//
//  WeatherCacheStore.swift
//  Skyscanner
//
//  Created by debmalyakar on 21/10/26.
//

import Foundation
import SwiftData



protocol PlacesSelectionStore : ModelActor{
    /// Persists the place (or finds it if it is already saved) and returns its coordinate.
    func save(place: GeocodingResult) throws -> PlaceCoordinate
}

@ModelActor
actor WeatherCacheStoreImpl {

   /// Air quality arrives from a different host, so it lands separately and
   /// must not disturb `weatherFetchedAt`.
   func updateAirQuality(placeID: Int, europeanAQI: Int?, pm25: Double?, fetchedAt: Date = .now) throws {
       let descriptor = FetchDescriptor<SavedPlace>(predicate: #Predicate { $0.id == placeID })
       guard let current = try modelContext.fetch(descriptor).first?.current else { return }

       current.europeanAQI = europeanAQI
       current.pm25 = pm25
       current.airQualityFetchedAt = fetchedAt

       try modelContext.save()
   }
}

extension WeatherCacheStoreImpl : PlacesSelectionStore {
    func save(place: GeocodingResult) throws -> PlaceCoordinate {
        dispatchPrecondition(condition: .notOnQueue(.main))   // crashes in debug if on main
        // Already saved: return it as is. Inserting again would upsert over the
        // unique id and wipe its cached weather and `weatherFetchedAt`.
        if let existing = try savedPlace(with: place.id) {
            return existing.toPlaceCoordinate()
        }
        let savedPlace = SavedPlace(place)
        modelContext.insert(savedPlace)
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
        return savedPlace.toPlaceCoordinate()
    }
}


