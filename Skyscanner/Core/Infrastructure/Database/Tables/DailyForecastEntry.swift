//
//  DailyForecastEntry.swift
//  Skyscanner
//
//  Created by debmalyakar on 19/10/26.
//

import Foundation
import SwiftData


// MARK: - 3. DailyForecastEntry — seven rows per place

@Model
final class DailyForecastEntry {

    var place: SavedPlace?

    /// Start of the local calendar day in the PLACE's time zone, not the device's.
    /// Build it with a Calendar whose timeZone is the place's, or rows drift by a day
    /// for anyone travelling or looking at a far-off city.
    var date: Date

    var weatherCode: Int                   // weather_code                    → row icon
    var tempMax: Double                    // temperature_2m_max              → "H 27°"
    var tempMin: Double                    // temperature_2m_min              → "L 16°"
    var tempMean: Double?                  // temperature_2m_mean             → average column
    var precipitationProbabilityMax: Double // precipitation_probability_max  → "60%"
    var precipitationSum: Double?          // precipitation_sum, mm           → rain view
    var windSpeedMax: Double               // wind_speed_10m_max, km/h        → wind view
    var windGustsMax: Double?              // wind_gusts_10m_max
    var uvIndexMax: Double                 // uv_index_max                    → Conditions "6 High"
    var sunrise: Date                      // sunrise                         → sun arc
    var sunset: Date                       // sunset                          → sun arc

    init(
        date: Date,
        weatherCode: Int,
        tempMax: Double,
        tempMin: Double,
        tempMean: Double? = nil,
        precipitationProbabilityMax: Double,
        precipitationSum: Double? = nil,
        windSpeedMax: Double,
        windGustsMax: Double? = nil,
        uvIndexMax: Double,
        sunrise: Date,
        sunset: Date
    ) {
        self.date = date
        self.weatherCode = weatherCode
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.tempMean = tempMean
        self.precipitationProbabilityMax = precipitationProbabilityMax
        self.precipitationSum = precipitationSum
        self.windSpeedMax = windSpeedMax
        self.windGustsMax = windGustsMax
        self.uvIndexMax = uvIndexMax
        self.sunrise = sunrise
        self.sunset = sunset
    }
}
