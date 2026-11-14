//
//  PlacesSelectionUseCase.swift
//  Skyscanner
//
//  Created by debmalyakar on 25/10/26.
//

import Foundation
protocol PlacesSelectionUseCase {
    /// Saves the place and returns its coordinate, so the caller can refresh just that place.
    func savePlace(_ id : Int , geoCodingResult : GeocodingResult) async throws -> PlaceCoordinate
}

nonisolated final class PlacesSelectionUseCaseImpl : PlacesSelectionUseCase {
    var placesSelectionRepository : PlaceSelectionRepository
    
    init(placesSelectionRepository: PlaceSelectionRepository) {
        self.placesSelectionRepository = placesSelectionRepository
    }
    
    func savePlace(_ id : Int , geoCodingResult : GeocodingResult) async throws -> PlaceCoordinate {
       try await placesSelectionRepository.selectPlace(id, geoCodingResult: geoCodingResult)
    }
    
}

