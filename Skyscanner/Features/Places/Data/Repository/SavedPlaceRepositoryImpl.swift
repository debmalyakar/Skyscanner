//
//  SavedPlaceRepositoryImpl.swift
//  Skyscanner
//
//  Created by debmalyakar on 04/11/26.
//

import Foundation

final nonisolated class SavedPlaceRepositoryImpl<DataSource : SavedPlaceLocalDataSource>: SavedPlaceRepository {
    private let local: DataSource
 
    init(local: DataSource) {
        self.local = local
    }
 
    @concurrent func getAllSavedPlaces() async throws -> [PlaceCoordinate] {
        try await local.fetchAllCoordinates()
    }
}
