//
//  MockUrlSession.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 26/09/26.
//

import Foundation
@testable import Skyscanner


class MockUrlSession : URLSessionProtocol {
    var urls: [URL] = []
    var response : (Data, URLResponse)?
    var error : Error?
    
    init(response: (Data, URLResponse)? = nil, error: Error? = nil) {
        self.response = response
        self.error = error
    }
    
    func data(
        from url: URL
    ) async throws -> (Data, URLResponse) {
        
        urls.append(url)
        if let error {
            throw error
        }
        if let response = response {
            return response
        }
        
        let response = (Data(), URLResponse())
        return response
    }

    
}

extension MockUrlSession {
    static func success(statusCode: Int = 200, data: Data, url: URL = URL(string: "https://example.com")!) -> MockUrlSession {
        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return MockUrlSession(response: (data, httpResponse))
    }

    static func failure(_ error: Error) -> MockUrlSession {
        MockUrlSession(error: error)
    }
}


class DummyApiClient : ApiClient {
    
    typealias T = DummyDecodable
    
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

}
