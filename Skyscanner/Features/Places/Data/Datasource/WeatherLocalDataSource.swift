//
//  WeatherLocalDataSource.swift
//  Skyscanner
//
//  Created by debmalyakar on 06/11/26.
//

import Foundation
import SwiftData

protocol WeatherLocalDataSource : Sendable {
    /// Replaces the stored weather for each place with its matching DTO.
       /// Pairs must already be matched (place[i] ↔ dto[i]).
       func replaceWeather(_ pairs: [(PlaceCoordinate, ForecastResponseDTO)])async throws
//       func apply(_ dto: ForecastResponseDTO, to place: SavedPlace)
}

extension WeatherCacheStoreImpl : WeatherLocalDataSource {
    func replaceWeather(_ pairs: [(PlaceCoordinate, ForecastResponseDTO)])async throws {
        dispatchPrecondition(condition: .notOnQueue(.main))   // crashes in debug if on main
        let now = Date()
        do{
            for (coordinate , dto) in pairs {
                guard let place = try savedPlace(with: coordinate.id) else { continue }
                apply(dto, to: place)
                place.weatherFetchedAt = now
            }
            try modelContext.save()
        }catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func savedPlace(with id: Int) throws -> SavedPlace? {
       var descriptor = FetchDescriptor<SavedPlace>(
                   predicate: #Predicate { $0.id == id }
               )
       descriptor.fetchLimit = 1
       return try modelContext.fetch(descriptor).first
    }
    
    func apply(_ dto: ForecastResponseDTO, to place: SavedPlace) {
        // --- Current weather ---
               // Air quality comes from a different API on its own schedule,
               // so carry the old values over to the new row.
               let previous = place.current
               let oldAQI = previous?.europeanAQI
               let oldPM25 = previous?.pm25
               let oldAQIFetchedAt = previous?.airQualityFetchedAt
        
               if let previous { modelContext.delete(previous) }
        
               if let current = dto.makeCurrentWeather() {
                   current.europeanAQI = oldAQI
                   current.pm25 = oldPM25
                   current.airQualityFetchedAt = oldAQIFetchedAt
                   place.current = current      // sets current.place via the inverse
               } else {
                   place.current = nil
               }
        
             
        // --- Hourly ---
        // Removing a child from the array does NOT delete it (cascade only fires
        // when the place itself is deleted), so delete the old rows explicitly.
                for hourlyForecast in place.hours { modelContext.delete(hourlyForecast) }
                place.hours = dto.makeHourlyEntries()

        
        // --- Daily ---
               for entry in place.days { modelContext.delete(entry) }
               place.days = dto.makeDailyEntries()
        
               // Assigning new objects to a relationship of a model that is already in
               // the context inserts them automatically; no separate context.insert needed.
    }
}
