//
//  HourlyForecastEntry.swift
//  Skyscanner
//
//  Created by debmalyakar on 19/10/26.
//

import Foundation
import SwiftData

// MARK: - 4. HourlyForecastEntry — the next 48 hours per place

@Model
final class HourlyForecastEntry {

    var place: SavedPlace?

    /// The hour this row describes. Open-Meteo's hourly values cover the hour
    /// ENDING at this timestamp, which matters when you turn them into "rain at 17:00".
    var time: Date

    var temperature: Double                 // temperature_2m           → hourly strip
    var apparentTemperature: Double?        // apparent_temperature
    var weatherCode: Int                    // weather_code             → strip icon
    var isDay: Bool                         // is_day                   → day/night icon
    var precipitation: Double               // precipitation, mm        → rain alert intensity
    var precipitationProbability: Double    // precipitation_probability, %
    var humidity: Double?                   // relative_humidity_2m
    var dewPoint: Double?                   // dew_point_2m             → copied to CurrentWeather
    var pressure: Double?                   // surface_pressure         → the 3h-ago trend value
    var visibility: Double?                 // visibility, m            → copied to CurrentWeather
    var windSpeed: Double?                  // wind_speed_10m
    var uvIndex: Double?                    // uv_index                 → UV through the day

    init(
        time: Date,
        temperature: Double,
        apparentTemperature: Double? = nil,
        weatherCode: Int,
        isDay: Bool,
        precipitation: Double,
        precipitationProbability: Double,
        humidity: Double? = nil,
        dewPoint: Double? = nil,
        pressure: Double? = nil,
        visibility: Double? = nil,
        windSpeed: Double? = nil,
        uvIndex: Double? = nil
    ) {
        self.time = time
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.weatherCode = weatherCode
        self.isDay = isDay
        self.precipitation = precipitation
        self.precipitationProbability = precipitationProbability
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.pressure = pressure
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.uvIndex = uvIndex
    }
}
