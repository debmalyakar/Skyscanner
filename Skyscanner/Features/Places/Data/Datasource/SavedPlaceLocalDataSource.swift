//
//  SavedPlaceLocalDataSource.swift
//  Skyscanner
//
//  Created by debmalyakar on 03/11/26.
//

import Foundation
import SwiftData

protocol SavedPlaceLocalDataSource  {
    func fetchAllCoordinates() async throws -> [PlaceCoordinate]
}
// Fetching all the coordinates from SavedPlace table
extension WeatherCacheStoreImpl : SavedPlaceLocalDataSource {
    func fetchAllCoordinates()async throws -> [PlaceCoordinate] {
        dispatchPrecondition(condition: .notOnQueue(.main))   // crashes in debug if on main
        let descriptor = FetchDescriptor<SavedPlace>(sortBy: [SortDescriptor(\.sortIndex)])
        return try modelContext.fetch(descriptor).map {
            $0.toPlaceCoordinate()
        }
    }
}

