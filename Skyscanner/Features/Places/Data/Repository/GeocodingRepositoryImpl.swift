//
//  GeocodingRepository.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation


final class GeocodingRepositoryImpl<RemoteDataSource : GeocodingFetchRemoteDataSource>: GeocodingRepository {
    
    var dataSource : RemoteDataSource
    
    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchGeocodingResults(query: String , count : Int) async throws -> [GeocodingResult] {
      let geocodingResultsDTO = try await dataSource.fetchGeocodingResults(query: query, count: count)
      return geocodingResultsDTO.map { $0.toDomain() }
    }
}


