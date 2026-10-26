//
//  WeatherCacheStore.swift
//  Skyscanner
//
//  Created by debmalyakar on 21/10/26.
//

import Foundation
import SwiftData


protocol WeatherCacheStore  : Sendable{
    
}

@ModelActor
actor WeatherCacheStoreImpl : WeatherCacheStore{

   /// Writes one full forecast response for one place: 1 current + 7 daily + 48 hourly.
   func replaceForecast(
       placeID: Int,
       current: CurrentWeather,
       days: [DailyForecastEntry],
       hours: [HourlyForecastEntry],
       fetchedAt: Date = .now
   ) throws {
       let descriptor = FetchDescriptor<SavedPlace>(predicate: #Predicate { $0.id == placeID })
       guard let place = try modelContext.fetch(descriptor).first else { return }

       // Cascade on the relationships removes the old rows when we clear them.
       place.current.map { modelContext.delete($0) }
       place.days.forEach { modelContext.delete($0) }
       place.hours.forEach { modelContext.delete($0) }

       current.place = place
       days.forEach { $0.place = place }
       hours.forEach { $0.place = place }

       modelContext.insert(current)
       days.forEach { modelContext.insert($0) }
       hours.forEach { modelContext.insert($0) }

       place.weatherFetchedAt = fetchedAt

       try modelContext.save()
   }

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
