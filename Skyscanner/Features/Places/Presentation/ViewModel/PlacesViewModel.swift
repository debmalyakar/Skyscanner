//
//  PlacesViewModel.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation
import SwiftUI

enum SearchState : Equatable {
    case idle
    case loading
    case results([GeocodingResult])
    case empty
    case failed(String)
}

@Observable
class PlacesViewModel {
    
    var query: String = ""
    
    var geocodingFetchUseCase : GeocodingFetchUseCase
        
    var asyncPlacesSelectionUseCaseFactory : () async -> PlacesSelectionUseCase
    
    var asyncRefreshWeatherUseCaseFactory : () async -> WeatherRefreshUseCase
    
    var debounceMilliSeconds : UInt64
    
    
    init(geocodingFetchUseCase: GeocodingFetchUseCase,
         debounceMilliSeconds : UInt64 = 300_000_000,
         asyncPlacesSelectionUseCaseFactory : @escaping() async -> PlacesSelectionUseCase ,
         asyncRefreshWeatherUseCaseFactory : @escaping() async -> WeatherRefreshUseCase
         ) {
        self.geocodingFetchUseCase = geocodingFetchUseCase
        self.debounceMilliSeconds = debounceMilliSeconds
        self.asyncPlacesSelectionUseCaseFactory = asyncPlacesSelectionUseCaseFactory
        self.asyncRefreshWeatherUseCaseFactory = asyncRefreshWeatherUseCaseFactory
    }
    
    var trimmedQuery: String { query.trimmingCharacters(in: .whitespacesAndNewlines) }
    
    var searchState : SearchState = .idle

    func fetchGeocodingResponse(query: String , debounce : Bool = true) async  {
        self.query = query
        let text = trimmedQuery
        guard text.count > 0 else {
            self.searchState = .idle
            return
        }
        if Task.isCancelled { return }
        
        if case .results = searchState {} else { searchState = .loading }
        if debounce {
            do { try await Task.sleep(nanoseconds: debounceMilliSeconds) } catch { return }
        }

        if Task.isCancelled { return }

        do {
         let results = try await geocodingFetchUseCase.fetchGeocoding(query: text)
            if results.isEmpty {
                self.searchState = .empty
            }else {
                self.searchState = .results(results)
            }
         print(results)
        }catch {
         self.searchState = .failed("Failed to Load !")
        }
    }
    
    /// The coordinate of the place the user most recently added, once it is saved.
    private(set) var selectedPlace: PlaceCoordinate?

    func willSelectPlace(_ place: GeocodingResult)  {
        Task { await selectPlace(place) }
    }

    /// Saves the place, then refreshes the weather for that place only.
    func selectPlace(_ place: GeocodingResult) async {
        let placesSelectionUseCase = await asyncPlacesSelectionUseCaseFactory()
        guard let coordinate = try? await placesSelectionUseCase.savePlace(place.id, geoCodingResult: place) else {
            return   // nothing was saved, so there is nothing to refresh
        }
        selectedPlace = coordinate

        // A failed refresh is not fatal: the place is saved and the next refreshAll retries it.
        let weatherRefreshUseCase = await asyncRefreshWeatherUseCaseFactory()
        try? await weatherRefreshUseCase.refresh(coordinate)
    }
}
