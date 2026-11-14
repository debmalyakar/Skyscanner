//
//  PlaceCoordinate.swift
//  Skyscanner
//
//  Created by debmalyakar on 11/11/26.
//

import Foundation

/// A saved place, reduced to what a weather refresh needs.
///
/// `id` is the place's own identity (the Open-Meteo geocoding ID, also `SavedPlace.id`),
/// not a persistence handle, so the domain layer stays free of SwiftData.
struct PlaceCoordinate: Sendable, Hashable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let weatherFetchedAt: Date?
}
