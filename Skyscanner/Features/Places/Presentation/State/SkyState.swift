//
//  SkyState.swift
//  Skyscanner
//
//  Created by debmalyakar on 17/11/26.
//

import Foundation
import SwiftUI
enum SkyState {
    case zenith, goldenHour, midnight, downpour, thunder, flurry, haze

        init(_ s: PlaceWeatherSummary, now: Date = .now) {
            switch s.condition {
            case .thunderstorm:                     self = .thunder
            case .snow:                             self = .flurry
            case .fog:                              self = .haze
            case .drizzle, .rain, .showers:         self = .downpour
            case .clear, .partlyCloudy, .overcast, nil:
                if !s.isDay { self = .midnight }
                else if Self.isGoldenHour(now, sunrise: s.sunrise, sunset: s.sunset) { self = .goldenHour }
                else { self = .zenith }
            }
        }
    /// The colors to use for the sky background
    var color: Color {
           switch self {
           case .zenith: .zenith
           case .goldenHour: .goldenHour
           case .midnight: .midnight
           case .downpour: .downpour
           case .thunder: .thunder
           case .flurry: .flurry
           case .haze: .haze
           }
       }

       private static func isGoldenHour(_ now: Date, sunrise: Date?, sunset: Date?) -> Bool {
           let window: TimeInterval = 45 * 60
           return [sunrise, sunset].compactMap { $0 }.contains { abs(now.timeIntervalSince($0)) <= window }
       }
}
