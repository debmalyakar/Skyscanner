//
//  SavedPlace.swift
//  Skyscanner
//
//  Created by debmalyakar on 19/10/26.
//

import Foundation
import SwiftData


// MARK: - 1. SavedPlace — the city itself (from the Geocoding API)

@Model
final class SavedPlace {

    /// Open-Meteo geocoding ID. Unique, so the same city can never be added twice.
    /// The current-location row uses `SavedPlace.currentLocationID`, since it has no geocoding ID.
    @Attribute(.unique) var id: Int

    // Identity, from the geocoding result.
    var name: String                  // "Lisbon"
    var region: String?               // admin1: "Lisbon District", "Florida"
    var subregion: String?            // admin2: "Lisbon Municipality"
    var country: String?              // "Portugal", absent for a few places
    var countryCode: String?          // "PT"
    var latitude: Double
    var longitude: Double
    var timeZoneID: String            // "Europe/Lisbon", drives the local clock on the card
    var elevation: Double?            // metres

    // User state.
    var isCurrentLocation: Bool
    var sortIndex: Int
    var addedAt: Date

    /// When the forecast request last succeeded for this place.
    var weatherFetchedAt: Date?

    // Relationships. Deleting the place deletes all of its weather.
    @Relationship(deleteRule: .cascade, inverse: \CurrentWeather.place)
    var current: CurrentWeather?

    @Relationship(deleteRule: .cascade, inverse: \DailyForecastEntry.place)
    var days: [DailyForecastEntry] = []

    @Relationship(deleteRule: .cascade, inverse: \HourlyForecastEntry.place)
    var hours: [HourlyForecastEntry] = []

    static let currentLocationID = -1

    init(
        id: Int,
        name: String,
        region: String? = nil,
        subregion: String? = nil,
        country: String? = nil,
        countryCode: String? = nil,
        latitude: Double,
        longitude: Double,
        timeZoneID: String,
        elevation: Double? = nil,
        isCurrentLocation: Bool = false,
        sortIndex: Int = 0,
        addedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.region = region
        self.subregion = subregion
        self.country = country
        self.countryCode = countryCode
        self.latitude = latitude
        self.longitude = longitude
        self.timeZoneID = timeZoneID
        self.elevation = elevation
        self.isCurrentLocation = isCurrentLocation
        self.sortIndex = sortIndex
        self.addedAt = addedAt
    }
}



extension SavedPlace {

    var timeZone: TimeZone { TimeZone(identifier: timeZoneID) ?? .current }

    /// "Lisbon · Portugal". The region is dropped when it just repeats the name,
    /// which also catches "Lisbon District" for Lisbon and "New York" for New York.
    var subtitle: String {
        let showRegion = region.map { !$0.localizedCaseInsensitiveContains(name) } ?? false
        return [showRegion ? region : nil, country]
            .compactMap { $0?.isEmpty == false ? $0 : nil }
            .joined(separator: " · ")
    }

    /// Flag emoji from the country code ("PT" → 🇵🇹).
    var flag: String? {
        guard let code = countryCode?.uppercased(), code.count == 2 else { return nil }
        let scalars = code.unicodeScalars.compactMap { UnicodeScalar(127397 + $0.value) }
        return String(String.UnicodeScalarView(scalars))
    }

    func today(at now: Date = .now) -> DailyForecastEntry? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return days.first { calendar.isDate($0.date, inSameDayAs: now) }
    }

    var sortedDays: [DailyForecastEntry] {
        days.sorted { $0.date < $1.date }
    }

    /// Includes the hour in progress (at 14:20 the 14:00 slot is "now"),
    /// so the strip doesn't skip the current hour.
    func upcomingHours(_ count: Int = 24, at now: Date = .now) -> [HourlyForecastEntry] {
        let startOfHour = now.addingTimeInterval(-3600)
        return hours.filter { $0.time > startOfHour }
            .sorted { $0.time < $1.time }
            .prefix(count)
            .map { $0 }
    }

    func isWeatherStale(maxAge: TimeInterval, at now: Date = .now) -> Bool {
        guard let weatherFetchedAt else { return true }
        return now.timeIntervalSince(weatherFetchedAt) >= maxAge
    }
}
