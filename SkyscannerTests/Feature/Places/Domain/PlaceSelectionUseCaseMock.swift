//
//  PlaceSelectionUseCase.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 26/10/26.
//

import Foundation
@testable import Skyscanner

final class PlaceSelectionUseCaseMock : PlacesSelectionUseCase {
    var stubbedCoordinate = PlaceCoordinate(id: 1, latitude: 22.57, longitude: 88.36, weatherFetchedAt: nil)
    var stubbedError: Error?
    private(set) var savedPlaces: [GeocodingResult] = []

    func savePlace(_ id: Int, geoCodingResult: GeocodingResult) async throws -> PlaceCoordinate {
        savedPlaces.append(geoCodingResult)
        if let stubbedError { throw stubbedError }
        return stubbedCoordinate
    }
}
