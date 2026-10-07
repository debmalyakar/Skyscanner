//
//  GeoCodingRepositoryMock.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 30/09/26.
//

@testable import Skyscanner
import Foundation

class GeoCodingRepositoryMock : GeocodingRepository {
    var countToCheck : Int = 0
    var queryToCheck : String = ""
    
    var result : Result<[GeocodingResult], Error>
    
    init(result : Result<[GeocodingResult], Error>) {
        self.result = result
    }
    
    func fetchGeocodingResults(query : String , count : Int) async throws -> [GeocodingResult] {
        countToCheck = count
        queryToCheck = query
        switch result {
        case .success(let results):
            return results
        case .failure(let error):
            throw error
        }
    }

}
