//
//  GeocodingFetch.swift
//  Skyscanner
//
//  Created by debmalyakar on 24/09/26.
//

import Foundation

protocol GeocodingFetchUseCaseProtocol {
    func fetchGeocoding(query : String) async throws -> [GeocodingResult]
}

final class GeocodingFetchUseCase<Repository : GeocodingRepository> : GeocodingFetchUseCaseProtocol {
    var goecodingRepo : Repository
    init(goecodingRepo: Repository) {
        self.goecodingRepo = goecodingRepo
    }
    func fetchGeocoding(query : String) async throws -> [GeocodingResult] {
       try await goecodingRepo.fetchGeocodingResults(query: query, count: 10)
    }
}
