//
//  GeocodingDTO.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation

// MARK: - Geocoding API (search)

struct GeocodingResultDTO: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
    let timezone: String?
}

struct GeocodingResponseDTO: Decodable {
    let results: [GeocodingResultDTO]?
}

extension GeocodingResultDTO {
    func toDomain() -> GeocodingResult {
        .init(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            country: country,
            admin1: admin1,
            timezone: timezone
        )
    }
}
