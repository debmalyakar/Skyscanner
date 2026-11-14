//
//  WeatherRepository.swift
//  Skyscanner
//
//  Created by debmalyakar on 06/11/26.
//

import Foundation

protocol WeatherRepository {
   @concurrent func fetchWeatherData(for coordinates: [PlaceCoordinate]) async throws
}
