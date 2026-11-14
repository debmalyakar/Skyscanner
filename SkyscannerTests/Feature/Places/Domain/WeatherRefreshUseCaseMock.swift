//
//  WeatherRefreshUseCaseMock.swift
//  SkyscannerTests
//
//  Created by debmalyakar on 11/11/26.
//

import Foundation
@testable import Skyscanner

final class WeatherRefreshUseCaseMock : WeatherRefreshUseCase {
    private(set) var refreshedPlaces: [PlaceCoordinate] = []
    private(set) var refreshAllCalls: [Bool] = []

    func refreshAll(force: Bool) async throws {
        refreshAllCalls.append(force)
    }

    func refresh(_ place: PlaceCoordinate) async throws {
        refreshedPlaces.append(place)
    }
}
