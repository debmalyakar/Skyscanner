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
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
    let timezone: String?
}
