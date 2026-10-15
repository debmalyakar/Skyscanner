//
//  GeoCodingRepositoryMock.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 28/09/26.
//

@testable import Skyscanner
import Foundation

class GeoCodingRemoteDataSourceMock : GeocodingFetchRemoteDataSource {
    var queryToCheck = ""
    var countToCheckInQuery = 0
    var response : Result<[GeocodingResultDTO] , Error>
    
    private init(response: Result<[GeocodingResultDTO], Error>) {
        self.response = response
    }
    
    func fetchGeocodingResults(query: String, count: Int) async throws -> [GeocodingResultDTO] {
        queryToCheck = query
        countToCheckInQuery = count
        switch response {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }
}

extension GeoCodingRemoteDataSourceMock {
    static func success(with result: [GeocodingResultDTO]) -> GeoCodingRemoteDataSourceMock {
        return GeoCodingRemoteDataSourceMock(response: .success(result))
    }
    
    static func failure(with error: Error) -> GeoCodingRemoteDataSourceMock {
        return GeoCodingRemoteDataSourceMock(response: .failure(error))
    }
}
