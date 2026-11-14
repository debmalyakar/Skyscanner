//
//  WeatherAPIClient.swift
//  Skyscanner
//
//  Created by debmalyakar on 31/10/26.
//

import Foundation
class WeatherAPIClient : ApiClient {
    var urlSession : URLSessionProtocol
    init(urlSession: URLSessionProtocol = URLSession.shared ) {
        self.urlSession = urlSession
    }
    typealias T = ForecastBatchDTO
}
