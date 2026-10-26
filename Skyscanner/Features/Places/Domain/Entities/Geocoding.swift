//
//  Geocoding.swift
//  Skyscanner
//
//  Created by debmalyakar on 24/09/26.
//

import Foundation

struct GeocodingResult: Identifiable, Equatable {
    let id: Int
    let name: String
    let region: String?
    let subregion: String?
    let country: String?
    let countryCode: String?
    let latitude: Double
    let longitude: Double
    let timeZoneID: String
    let elevation: Double?
}
