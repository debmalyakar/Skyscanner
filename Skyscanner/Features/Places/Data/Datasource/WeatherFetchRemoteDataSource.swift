//
//  WeatherFetchDataSource.swift
//  Skyscanner
//
//  Created by debmalyakar on 31/10/26.
//

import Foundation
protocol WeatherFetchRemoteDataSource {
    func fetchWeather(latitudes : [Double] , longitudes : [Double]) async throws -> [ForecastResponseDTO]
}

final class WeatherFetchRemoteDataSourceImpl: WeatherFetchRemoteDataSource {
    
    var apiClient : any ApiClient<ForecastBatchDTO>
    init(apiClient: any ApiClient<ForecastBatchDTO>) {
        self.apiClient = apiClient
    }
    
    func fetchWeather(latitudes: [Double], longitudes: [Double]) async throws -> [ForecastResponseDTO] {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            .init(name: "latitude", value: latitudes.map{String($0)}.joined(separator:",")),
               .init(name: "longitude", value: longitudes.map{String($0)}.joined(separator:",")),
               .init(name: "current", value: [
                   "temperature_2m", "apparent_temperature", "weather_code", "is_day",
                   "relative_humidity_2m", "surface_pressure", "wind_speed_10m",
                   "wind_direction_10m", "wind_gusts_10m", "precipitation"
               ].joined(separator: ",")),
               .init(name: "hourly", value: [
                   "temperature_2m", "apparent_temperature", "weather_code", "is_day",
                   "precipitation", "precipitation_probability", "relative_humidity_2m",
                   "dew_point_2m", "surface_pressure", "visibility", "wind_speed_10m", "uv_index"
               ].joined(separator: ",")),
               .init(name: "daily", value: [
                   "weather_code", "temperature_2m_max", "temperature_2m_min", "temperature_2m_mean",
                   "precipitation_probability_max", "precipitation_sum", "wind_speed_10m_max",
                   "wind_gusts_10m_max", "uv_index_max", "sunrise", "sunset"
               ].joined(separator: ",")),
               .init(name: "forecast_days", value: "7"),
               .init(name: "timezone", value: "auto"),
               .init(name: "timeformat", value: "unixtime"),
               .init(name: "past_hours", value: "3")
           ]
        do {
            let response : ForecastBatchDTO = try await apiClient.getResponse(from: components)
            return response.forecasts
        }catch  let error as NetworkError {
            if error == .parseError {
                return []
            }else {
                throw error
            }
        } catch {
            throw error
        }
    }
}
