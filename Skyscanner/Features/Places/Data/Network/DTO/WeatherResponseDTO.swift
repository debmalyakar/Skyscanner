//
//  WeatherResponseDTO.swift
//  Skyscanner
//
//  Created by debmalyakar on 31/10/26.
//

import Foundation

// MARK: - Root
//ForecastResponseDTO can be an array or a single object, Hence this object is required to always convert into an array
nonisolated struct ForecastBatchDTO: Decodable {
    let forecasts: [ForecastResponseDTO]
 
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            forecasts = try container.decode([ForecastResponseDTO].self)
        }catch {
            forecasts = [try container.decode(ForecastResponseDTO.self)]
        }
    }
}
 
nonisolated struct ForecastResponseDTO: Decodable {
    let latitude: Double
    let longitude: Double
    let utcOffsetSeconds: Int
    let timezone: String
    let timezoneAbbreviation: String?
    let elevation: Double?
 
    let current: CurrentDTO?
    let hourly: HourlyDTO?
    let daily: DailyDTO?
 
    // The *_units blocks are ignored: the app requests fixed units (°C, km/h, mm, hPa).
 
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, timezone, elevation, current, hourly, daily
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezoneAbbreviation = "timezone_abbreviation"
    }
 
    /// The place's own time zone. Use it for anything calendar-based (daily rows).
    var placeTimeZone: TimeZone {
        TimeZone(identifier: timezone)
            ?? TimeZone(secondsFromGMT: utcOffsetSeconds)
            ?? .gmt
    }
}


// MARK: - Current
 
nonisolated struct CurrentDTO: Decodable {
    let time: TimeInterval
    let interval: Int?
 
    let temperature2m: Double
    let apparentTemperature: Double
    let weatherCode: Int
    let isDay: Int
    let relativeHumidity2m: Double
    let surfacePressure: Double
    let windSpeed10m: Double
    let windDirection10m: Double
    let windGusts10m: Double
    /// Not in the sample response; add `precipitation` to the `current=` list.
    let precipitation: Double?
 
    enum CodingKeys: String, CodingKey {
        case time, interval, precipitation
        case temperature2m       = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case weatherCode         = "weather_code"
        case isDay               = "is_day"
        case relativeHumidity2m  = "relative_humidity_2m"
        case surfacePressure     = "surface_pressure"
        case windSpeed10m        = "wind_speed_10m"
        case windDirection10m    = "wind_direction_10m"
        case windGusts10m        = "wind_gusts_10m"
    }
}


// MARK: - Hourly (columnar: one array per variable, all indexed by `time`)

nonisolated struct HourlyDTO: Decodable {
   let time: [TimeInterval]

   // Required by HourlyForecastEntry. Elements are optional because Open-Meteo
   // can send `null` inside an array; rows with a null required value are skipped.
   let temperature2m: [Double?]
   let weatherCode: [Int?]
   let isDay: [Int?]
   let precipitation: [Double?]
   let precipitationProbability: [Double?]

   // Optional columns (absent from the sample response).
   let apparentTemperature: [Double?]?
   let relativeHumidity2m: [Double?]?
   let dewPoint2m: [Double?]?
   let surfacePressure: [Double?]?
   let visibility: [Double?]?
   let windSpeed10m: [Double?]?
   let uvIndex: [Double?]?

   enum CodingKeys: String, CodingKey {
       case time, precipitation, visibility
       case temperature2m            = "temperature_2m"
       case weatherCode              = "weather_code"
       case isDay                    = "is_day"
       case precipitationProbability = "precipitation_probability"
       case apparentTemperature      = "apparent_temperature"
       case relativeHumidity2m       = "relative_humidity_2m"
       case dewPoint2m               = "dew_point_2m"
       case surfacePressure          = "surface_pressure"
       case windSpeed10m             = "wind_speed_10m"
       case uvIndex                  = "uv_index"
   }

   /// Index of the row closest to `date`, if one lies within `tolerance` seconds.
   func nearestIndex(to date: Date, tolerance: TimeInterval) -> Int? {
       let target = date.timeIntervalSince1970
       guard let best = time.indices.min(by: { abs(time[$0] - target) < abs(time[$1] - target) }),
             abs(time[best] - target) <= tolerance
       else { return nil }
       return best
   }
}

// MARK: - Daily (columnar)
 
nonisolated struct DailyDTO: Decodable {
    let time: [TimeInterval]
 
    // Required by DailyForecastEntry.
    let weatherCode: [Int?]
    let temperature2mMax: [Double?]
    let temperature2mMin: [Double?]
    let precipitationProbabilityMax: [Double?]
    let windSpeed10mMax: [Double?]
    let uvIndexMax: [Double?]
    let sunrise: [TimeInterval?]
    let sunset: [TimeInterval?]
 
    // Optional columns.
    let temperature2mMean: [Double?]?
    let precipitationSum: [Double?]?
    let windGusts10mMax: [Double?]?
 
    enum CodingKeys: String, CodingKey {
        case time, sunrise, sunset
        case weatherCode                 = "weather_code"
        case temperature2mMax            = "temperature_2m_max"
        case temperature2mMin            = "temperature_2m_min"
        case temperature2mMean           = "temperature_2m_mean"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case precipitationSum            = "precipitation_sum"
        case windSpeed10mMax             = "wind_speed_10m_max"
        case windGusts10mMax             = "wind_gusts_10m_max"
        case uvIndexMax                  = "uv_index_max"
    }
}
 
nonisolated extension ForecastResponseDTO {
    
    /// Builds CurrentWeather from `current`, then copies dew point, visibility and the
      /// 3-hour-old pressure from the hourly block.
      func makeCurrentWeather() -> CurrentWeather? {
          guard let c = current else { return nil }
          let observedAt = Date(timeIntervalSince1970: c.time)
   
          var dewPoint: Double?
          var visibility: Double?
          var pressure3hAgo: Double?
   
          if let h = hourly {
              // `current` is on a 15-min grid, hourly on the hour: nearest row is ≤ 30 min away.
              if let i = h.nearestIndex(to: observedAt, tolerance: 45 * 60) {
                  dewPoint = column(h.dewPoint2m, i)
                  visibility = column(h.visibility, i)
              }
              // Needs `past_hours=3` (or more) so the earlier rows exist.
              if let i = h.nearestIndex(to: observedAt.addingTimeInterval(-3 * 3600), tolerance: 45 * 60) {
                  pressure3hAgo = column(h.surfacePressure, i)
              }
          }
   
          return CurrentWeather(
              observedAt: observedAt,
              temperature: c.temperature2m,
              apparentTemperature: c.apparentTemperature,
              weatherCode: c.weatherCode,
              isDay: c.isDay == 1,
              humidity: c.relativeHumidity2m,
              pressure: c.surfacePressure,
              windSpeed: c.windSpeed10m,
              windDirection: c.windDirection10m,
              windGusts: c.windGusts10m,
              precipitation: c.precipitation ?? 0,
              dewPoint: dewPoint,
              visibility: visibility,
              pressure3hAgo: pressure3hAgo
          )
      }
    
    /// One entry per hourly timestamp. Rows missing a required value are skipped.
      func makeHourlyEntries() -> [HourlyForecastEntry] {
          guard let h = hourly else { return [] }
   
          return h.time.indices.compactMap { i in
              guard
                  let temperature = column(h.temperature2m, i),
                  let code        = column(h.weatherCode, i),
                  let isDay       = column(h.isDay, i),
                  let precip      = column(h.precipitation, i),
                  let precipProb  = column(h.precipitationProbability, i)
              else { return nil }
   
              return HourlyForecastEntry(
                  time: Date(timeIntervalSince1970: h.time[i]),
                  temperature: temperature,
                  apparentTemperature: column(h.apparentTemperature, i),
                  weatherCode: code,
                  isDay: isDay == 1,
                  precipitation: precip,
                  precipitationProbability: precipProb,
                  humidity: column(h.relativeHumidity2m, i),
                  dewPoint: column(h.dewPoint2m, i),
                  pressure: column(h.surfacePressure, i),
                  visibility: column(h.visibility, i),
                  windSpeed: column(h.windSpeed10m, i),
                  uvIndex: column(h.uvIndex, i)
              )
          }
      }
    
    func makeDailyEntries() -> [DailyForecastEntry] {
          guard let d = daily else { return [] }
   
          var calendar = Calendar(identifier: .gregorian)
          calendar.timeZone = placeTimeZone
   
          return d.time.indices.compactMap { i in
              guard
                  let code       = column(d.weatherCode, i),
                  let tMax       = column(d.temperature2mMax, i),
                  let tMin       = column(d.temperature2mMin, i),
                  let precipProb = column(d.precipitationProbabilityMax, i),
                  let windMax    = column(d.windSpeed10mMax, i),
                  let uvMax      = column(d.uvIndexMax, i),
                  let sunrise    = column(d.sunrise, i),
                  let sunset     = column(d.sunset, i)
              else { return nil }
   
              // With timeformat=unixtime Open-Meteo already sends local midnight;
              // startOfDay just guarantees it against the place's calendar.
              let day = calendar.startOfDay(for: Date(timeIntervalSince1970: d.time[i]))
   
              return DailyForecastEntry(
                  date: day,
                  weatherCode: code,
                  tempMax: tMax,
                  tempMin: tMin,
                  tempMean: column(d.temperature2mMean, i),
                  precipitationProbabilityMax: precipProb,
                  precipitationSum: column(d.precipitationSum, i),
                  windSpeedMax: windMax,
                  windGustsMax: column(d.windGusts10mMax, i),
                  uvIndexMax: uvMax,
                  sunrise: Date(timeIntervalSince1970: sunrise),
                  sunset: Date(timeIntervalSince1970: sunset)
              )
          }
      }
    
    nonisolated private func column<T>(_ values: [T?]?, _ index: Int) -> T? {
        guard let values, values.indices.contains(index) else { return nil }
        return values[index]
    }
}
