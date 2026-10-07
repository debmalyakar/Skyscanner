//
//  GeoCodingRemoteDatasource.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation

protocol GeocodingFetchRemoteDataSource {
    func fetchGeocodingResults(query : String , count : Int) async throws -> [GeocodingResultDTO]
}


final class GeocodingFetchRemoteDataSourceImpl : GeocodingFetchRemoteDataSource {
    
    var apiClient : any ApiClient<GeocodingResponseDTO>
    init(apiClient: any ApiClient<GeocodingResponseDTO>) {
        self.apiClient = apiClient
    }
    
    func fetchGeocodingResults(query: String , count: Int) async throws -> [GeocodingResultDTO] {
        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        components.queryItems = [
            .init(name: "name", value: query),
            .init(name: "count", value: String(count)),
            .init(name: "language", value:  "en"),
            .init(name: "format", value: "json")
        ]
        do {
            let response : GeocodingResponseDTO = try await apiClient.getResponse(from: components)
            return response.results ?? []
        }catch  let error as NetworkError {
            if error == .parseError {
                return []
            }else {
                throw error
            }
        } catch {
            throw error
        }
    }
    
}
