//
//  PlaceSelectionRepository.swift
//  Skyscanner
//
//  Created by debmalyakar on 25/10/26.
//

import Foundation

protocol PlaceSelectionRepository {
    /// Saves the place, marks it as selected, and returns its coordinate for a weather refresh.
    func selectPlace(_ placeId: Int , geoCodingResult : GeocodingResult) async throws -> PlaceCoordinate
}
