//
//  PlaceWeatherSummary.swift
//  Skyscanner
//
//  Created by debmalyakar on 17/11/26.
//

import Foundation

struct PlaceWeatherSummary : Sendable , Identifiable , Equatable{
    let id : Int
    let name : String
    let timeZone : TimeZone
    let isCurrentLocation : Bool
    let condition : WeatherCondition?
    let isDay : Bool
    let temparature : Double?
    let high : Double?
    let low : Double?
    let sunrise : Date?
    let sunset : Date?
}
