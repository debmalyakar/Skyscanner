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
    init(userDefault: userDefaultSet = UserDefaults.standard) {
        self.userDefault = userDefault
    }
    
    func selectPlace(_ placeId: Int) {
        userDefault.set(placeId, forKey: key)
    }
}
