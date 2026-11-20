//
//  WeatherCondition.swift
//  Skyscanner
//
//  Created by debmalyakar on 17/11/26.
//

import Foundation

/// enum that converts weather condition from wmocode
enum WeatherCondition {
    case clear, partlyCloudy, overcast, fog, drizzle, rain, showers , snow, thunderstorm
    
    init(wmoCode : Int) {
        switch wmoCode {
        case 0: self = .clear
        case 1,2: self = .partlyCloudy
        case 3: self = .overcast
        case 45,48: self = .fog
        case 51...57: self = .drizzle
        case 61...67:           self = .rain
        case 80...82:           self = .showers
        case 71...77, 85, 86:   self = .snow
        case 95...99:           self = .thunderstorm
        default:                self = .overcast   // unknown codes: a neutral fallback
            
        }
    }
}
