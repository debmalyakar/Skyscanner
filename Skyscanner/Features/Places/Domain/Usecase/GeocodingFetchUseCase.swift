//
//  GeocodingFetch.swift
//  Skyscanner
//
//  Created by debmalyakar on 24/09/26.
//

import Foundation

class GeocodingFetchUseCase {
    var goecodingRepo : GeocodingRepository
    init(goecodingRepo: GeocodingRepository) {
        self.goecodingRepo = goecodingRepo
    }
    func fetchGeocoding(query : String) async throws -> [GeocodingResult] {
       try await goecodingRepo.fetchGeocodingResults(query: query, count: 10)
    }
}
