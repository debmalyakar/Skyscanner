//
//  GeocodingAPIClient.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation

class GeocodingAPIClient : ApiClient {
    var urlSession : URLSessionProtocol
    init(urlSession: URLSessionProtocol = URLSession.shared ) {
        self.urlSession = urlSession
    }
    typealias T = GeocodingResponseDTO
}

