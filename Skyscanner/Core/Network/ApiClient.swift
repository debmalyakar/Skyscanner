//
//  ApiClient.swift
//  Skyscanner
//
//  Created by debmalyakar on 20/09/26.
//

import Foundation

// Error scopes for network failures
enum NetworkError: Error, Equatable {
    case invalidURL
    case badResponse
    case decodingError
}

protocol ApiClient {
    associatedtype T : Decodable
    var urlSession : URLSessionProtocol {get set}
    func getResponse(from urlComponent : URLComponents ) async throws -> T
    @concurrent func decode(data : Data) async throws -> T
}

protocol URLSessionProtocol {
    func data(
        from url: URL
    ) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

/// Generics networking layer
extension ApiClient where T : Decodable{
    
    func getResponse(from urlComponent : URLComponents) async throws -> T {
        guard let url = urlComponent.url else {
            throw NetworkError.invalidURL
        }
        let (data , response) = try await urlSession.data(from: url)
        // Validate HTTP response status
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse
        }
        let _response : T = try await decode(data: data)
       return _response
    }
 
    @concurrent func decode(data : Data) async throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
   
}
