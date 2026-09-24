//
//  GeocodingRepository.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation


class GeocodingRepositoryImpl: GeocodingRepository {
    
    var dataSource : GeocodingFetchRemoteDataSource
    
    init(dataSource: GeocodingFetchRemoteDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchGeocodingResults(query: String , count : Int) async throws -> [GeocodingResult] {
      let geocodingResultsDTO = try await dataSource.fetchGeocodingResults(query: query, count: count)
      return geocodingResultsDTO.map { $0.toDomain() }
    }
}


