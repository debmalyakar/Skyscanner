//
//  GeocodingDTO.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation

// MARK: - Geocoding API (search)
struct GeocodingResponseDTO: Decodable {
    let results: [GeocodingResultDTO]?   // key is absent when nothing matches
}

struct GeocodingResultDTO: Decodable, Identifiable , Equatable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let elevation: Double?
    let featureCode: String?
    let countryCode: String?
    let timezone: String?
    let population: Int?
    let country: String?
    let admin1: String?
    let admin2: String?
}
// Decode with: decoder.keyDecodingStrategy = .convertFromSnakeCase

extension GeocodingResultDTO {
    func toDomain() -> GeocodingResult {
        .init(id: id,
              name: name,
              region: admin1,
              subregion: admin2,
              country: country,
              countryCode: countryCode,
              latitude: latitude,
              longitude: longitude,
              timeZoneID: timezone ?? "GMT",   // the forecast API returns the real one anyway
              elevation: elevation)
    }
}
