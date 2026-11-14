//
//  PlaceSelectionRepoImp.swift
//  Skyscanner
//
//  Created by debmalyakar on 25/10/26.
//

import Foundation

protocol PlacesUserDefaultsSet {
    func set(_ value: Int, forKey defaultName: String)
}

extension UserDefaults: PlacesUserDefaultsSet {}

final class PlaceSelectionRepoImpl<userDefaultSet : PlacesUserDefaultsSet> : PlaceSelectionRepository {
    private let userDefault : userDefaultSet
    private let key = "selectedPlaceId"
    private let placeStore : any PlacesSelectionStore
    
    init(userDefault: userDefaultSet = UserDefaults.standard ,
         placeStore : PlacesSelectionStore) {
        self.userDefault = userDefault
        self.placeStore = placeStore
    }
    
   @concurrent func selectPlace(_ placeId: Int , geoCodingResult : GeocodingResult) async throws -> PlaceCoordinate {
        // Save first, so the selection never points at a place that failed to persist.
        let coordinate = try await placeStore.save(place : geoCodingResult)
        userDefault.set(placeId, forKey: key)
        return coordinate
    }
}
