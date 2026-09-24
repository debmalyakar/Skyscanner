//
//  GeocodingRemoteRepository.swift
//  Skyscanner
//
//  Created by debmalyakar on 24/09/26.
//

import Foundation

protocol GeocodingRepository {
    func fetchGeocodingResults(query : String , count : Int) async throws -> [GeocodingResult]
}
