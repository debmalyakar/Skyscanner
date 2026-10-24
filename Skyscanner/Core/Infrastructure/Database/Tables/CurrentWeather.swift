//
//  CurrentWeather.swift
//  Skyscanner
//
//  Created by debmalyakar on 19/10/26.
//

import Foundation
import SwiftData


// MARK: - 2. CurrentWeather — one row per place, "right now"

@Model
final class CurrentWeather {

    var place: SavedPlace?

    /// The observation time Open-Meteo reported (its `current.time`), not when we fetched.
    var observedAt: Date

    // --- From the forecast API's `current` block ---
    var temperature: Double           // temperature_2m, °C        → Today hero, Places card
    var apparentTemperature: Double   // apparent_temperature       → "Feels like 23°"
    var weatherCode: Int              // weather_code (WMO)         → icon + "Partly Cloudy"
    var isDay: Bool                   // is_day                     → night icons, sky state
    var humidity: Double              // relative_humidity_2m, %    → Today card, Conditions
    var pressure: Double              // surface_pressure, hPa      → Conditions "1016 hPa"
    var windSpeed: Double             // wind_speed_10m, km/h       → Today card, Conditions
    var windDirection: Double         // wind_direction_10m, °      → "From NW"
    var windGusts: Double             // wind_gusts_10m, km/h       → "gusts 26"
    var precipitation: Double         // precipitation, mm          → "raining now"

    // --- Copied from the hourly row nearest `observedAt` ---
    // Open-Meteo does NOT offer these two in its `current` block; they are hourly-only
    // variables. The Conditions tab shows them beside the current values, so the refresh
    // copies them down from the matching hour rather than making the UI go hunting.
    var dewPoint: Double?             // dew_point_2m, °C           → "Dew point 15°"
    var visibility: Double?           // visibility, metres         → "12 km · Clear view"

    /// Surface pressure three hours earlier, for the Conditions trend label
    /// ("Steady" / "Rising" / "Falling"). Fetch it with `past_hours=3` on the hourly
    /// block; without a second reading the trend cannot be computed at all.
    var pressure3hAgo: Double?

    // --- From the SEPARATE air-quality API (different host, so it can be nil or older) ---
    var europeanAQI: Int?             // european_aqi               → "18 Good"
    var pm25: Double?                 // pm2_5, µg/m³               → "PM2.5 · 8 µg/m³"
    var airQualityFetchedAt: Date?    // its own timestamp, its own staleness

    init(
        observedAt: Date,
        temperature: Double,
        apparentTemperature: Double,
        weatherCode: Int,
        isDay: Bool,
        humidity: Double,
        pressure: Double,
        windSpeed: Double,
        windDirection: Double,
        windGusts: Double,
        precipitation: Double,
        dewPoint: Double? = nil,
        visibility: Double? = nil,
        pressure3hAgo: Double? = nil
    ) {
        self.observedAt = observedAt
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.weatherCode = weatherCode
        self.isDay = isDay
        self.humidity = humidity
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.windGusts = windGusts
        self.precipitation = precipitation
        self.dewPoint = dewPoint
        self.visibility = visibility
        self.pressure3hAgo = pressure3hAgo
    }
}

extension CurrentWeather {

    enum PressureTrend { case rising, steady, falling, unknown }

    /// ±1 hPa over three hours is the usual "steady" band.
    var pressureTrend: PressureTrend {
        guard let earlier = pressure3hAgo else { return .unknown }
        let delta = pressure - earlier
        if delta > 1 { return .rising }
        if delta < -1 { return .falling }
        return .steady
    }

    /// Visibility in km, for the Conditions card.
    var visibilityKilometres: Double? {
        visibility.map { $0 / 1000 }
    }

    func isAirQualityStale(maxAge: TimeInterval, at now: Date = .now) -> Bool {
        guard let airQualityFetchedAt else { return true }
        return now.timeIntervalSince(airQualityFetchedAt) >= maxAge
    }
}
