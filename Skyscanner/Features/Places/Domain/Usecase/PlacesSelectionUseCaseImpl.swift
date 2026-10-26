//
//  PlacesSelectionUseCase.swift
//  Skyscanner
//
//  Created by debmalyakar on 25/10/26.
//

import Foundation
protocol PlacesSelectionUseCase {
    func savePlaceId(_ id : Int)
}

final class PlacesSelectionUseCaseImpl : PlacesSelectionUseCase {
    var placesSelectionRepository : PlaceSelectionRepository
    
    init(placesSelectionRepository: PlaceSelectionRepository) {
        self.placesSelectionRepository = placesSelectionRepository
    }
    
    func savePlaceId(_ id : Int) {
        placesSelectionRepository.selectPlace(id)
    }
    
}

