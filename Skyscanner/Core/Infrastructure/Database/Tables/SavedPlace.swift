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
    @Attribute(.unique) var id: Int

    // Identity — everything the geocoding result gives us.
    var name: String                  // "Lisbon"
    var region: String?               // admin1, e.g. "Lisbon", "Florida"
    var country: String               // "Portugal"
    var countryCode: String?          // "PT" — for a flag, if you ever show one
    var latitude: Double
    var longitude: Double
    var timeZoneID: String            // "Europe/Lisbon" — drives the local clock on the card
    var elevation: Double?            // metres; Open-Meteo returns it, handy for display

    // User state.
    var isCurrentLocation: Bool       // the pinned CoreLocation row, always first
    var sortIndex: Int                // manual ordering in the Places list
    var addedAt: Date

    /// When the forecast request last succeeded for this place.
    /// This is the single value the freshness rule reads ("older than 20 min → refresh").
    /// It lives here, not on CurrentWeather, so the check works even before any
    /// weather has been downloaded, and survives a partially failed refresh.
    var weatherFetchedAt: Date?

    // Relationships. Deleting the place deletes all of its weather.
    @Relationship(deleteRule: .cascade, inverse: \CurrentWeather.place)
    var current: CurrentWeather?

    @Relationship(deleteRule: .cascade, inverse: \DailyForecastEntry.place)
    var days: [DailyForecastEntry] = []

    @Relationship(deleteRule: .cascade, inverse: \HourlyForecastEntry.place)
    var hours: [HourlyForecastEntry] = []

    init(
        id: Int,
        name: String,
        region: String? = nil,
        country: String,
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

    /// "Lisbon · Portugal" for the card subtitle (the region is dropped when it repeats the name).
    var subtitle: String {
        [region.flatMap { $0 == name ? nil : $0 }, country.isEmpty ? nil : country]
            .compactMap { $0 }
            .joined(separator: " · ")
    }

    /// Today's row, in the place's own time zone — the Places card's H/L and the
    /// Conditions sunrise/sunset come from here.
    func today(at now: Date = .now) -> DailyForecastEntry? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return days.first { calendar.isDate($0.date, inSameDayAs: now) }
    }

    /// The seven daily rows in order — the Forecast tab's chart and list.
    var sortedDays: [DailyForecastEntry] {
        days.sorted { $0.date < $1.date }
    }

    /// The next N whole hours — the Today tab's hourly strip and the rain alert.
    func upcomingHours(_ count: Int = 24, at now: Date = .now) -> [HourlyForecastEntry] {
        hours.filter { $0.time > now }
            .sorted { $0.time < $1.time }
            .prefix(count)
            .map { $0 }
    }

    /// True when the stored forecast is older than `maxAge`, or missing entirely.
    /// The use case owns the policy; this is just the comparison.
    func isWeatherStale(maxAge: TimeInterval, at now: Date = .now) -> Bool {
        guard let weatherFetchedAt else { return true }
        return now.timeIntervalSince(weatherFetchedAt) >= maxAge
    }
}
