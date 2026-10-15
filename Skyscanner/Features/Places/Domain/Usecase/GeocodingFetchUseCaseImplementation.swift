//
//  GeocodingFetch.swift
//  Skyscanner
//
//  Created by debmalyakar on 24/09/26.
//

import Foundation

protocol GeocodingFetchUseCase {
    func fetchGeocoding(query : String) async throws -> [GeocodingResult]
}

final class GeocodingFetchUseCaseImplementation<Repository : GeocodingRepository> : GeocodingFetchUseCase {
    var geocodingRepo : Repository
    init(geocodingRepo: Repository) {
        self.geocodingRepo = geocodingRepo
    }
    func fetchGeocoding(query : String) async throws -> [GeocodingResult] {
       try await geocodingRepo.fetchGeocodingResults(query: query, count: 10)
    }
}
