//
//  SavedPlaceRepository.swift
//  Skyscanner
//
//  Created by debmalyakar on 04/11/26.
//

import Foundation
protocol SavedPlaceRepository {
    @concurrent func getAllSavedPlaces() async throws -> [PlaceCoordinate]
}
