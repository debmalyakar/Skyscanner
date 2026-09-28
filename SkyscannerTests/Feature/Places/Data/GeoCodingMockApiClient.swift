//
//  GeoCodingMockApiClient.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 27/09/26.
//

@testable import Skyscanner
import Foundation

class GeoCodingMockApiClient: ApiClient {
    enum Input {
        case responseModel(Result<GeocodingResponseDTO , NetworkError>)
        case responseData(Result<Data, NetworkError>)
    }
    typealias T = GeocodingResponseDTO
    
    var urlSession: URLSessionProtocol
    var urlComponents : [URLComponents] = []
    
    var inputResponse : Input
    
    init(inputResponse: Input , urlSession: URLSessionProtocol = MockUrlSession()) {
        self.inputResponse = inputResponse
        self.urlSession = urlSession
    }
    
    func getResponse(from urlComponent: URLComponents) async throws -> GeocodingResponseDTO {
        urlComponents.append(urlComponent)
        switch inputResponse {
            case .responseData(let response):
            return try JSONDecoder().decode(GeocodingResponseDTO.self, from: response.get())
        case .responseModel(let response):
            return try response.get()
        }
    }
    
    
}
