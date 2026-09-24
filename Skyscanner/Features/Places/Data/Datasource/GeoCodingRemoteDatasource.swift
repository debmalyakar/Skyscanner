//
//  GeoCodingRemoteDatasource.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation

protocol GeocodingFetch {
    func getGeocodingResult(name : String) async throws -> [GeocodingResultDTO]
}

protocol GeocodingFetchRemoteDataSource {
    func fetchGeocodingResults(query : String , count : Int) async throws -> [GeocodingResultDTO]
}


class GeocodingFetchRemoteDataSourceImpl : GeocodingFetchRemoteDataSource {
    
    var apiClient : GeocodingAPIClient
    init(apiClient: GeocodingAPIClient) {
        self.apiClient = apiClient
    }
    
    func fetchGeocodingResults(query: String , count: Int) async throws -> [GeocodingResultDTO] {
        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        components.queryItems = [
            .init(name: "name", value: query),
            .init(name: "count", value: String(count)),
            .init(name: "language", value: Locale.current.language.languageCode?.identifier ?? "en"),
            .init(name: "format", value: "json")
        ]

        let response : GeocodingResponseDTO = try await apiClient.getResponse(from: components)
        return response.results ?? []
    }
    
}
