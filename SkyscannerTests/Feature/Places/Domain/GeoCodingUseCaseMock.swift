//
//  GeoCodingUseCaseMock.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 30/09/26.
//

import Foundation
@testable import Skyscanner
//func fetchGeocoding(query : String) async throws -> [GeocodingResult]

class GeoCodingUseCaseMock : GeocodingFetchUseCase {
   private(set) var capturedQueries : [String] = []
   private var continuation : CheckedContinuation<[GeocodingResult], Error>?
   private var callStartedContinuation : CheckedContinuation<Void , Never>?
    private var hasStarted = false
    
    func waitUntilCallStarts() async throws {
        guard !hasStarted else {
            return
        }
        await withCheckedContinuation { continuation in
            callStartedContinuation = continuation
        }
    }
    
    func fetchGeocoding(query: String) async throws -> [GeocodingResult] {
        capturedQueries.append(query)
        hasStarted = true
        callStartedContinuation?.resume()
        callStartedContinuation = nil
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }
    
    func resume(with result : Result<[GeocodingResult], Error>) {
        continuation?.resume(with: result)
        continuation = nil
    }

}
