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
    
    var placesSelectionUseCase : PlacesSelectionUseCase
    
    var debounceMilliSeconds : UInt64
    
    init(geocodingFetchUseCase: GeocodingFetchUseCase,
         placesSelectionUseCase : PlacesSelectionUseCase,
         debounceMilliSeconds : UInt64 = 300_000_000) {
        self.geocodingFetchUseCase = geocodingFetchUseCase
        self.placesSelectionUseCase = placesSelectionUseCase
        self.debounceMilliSeconds = debounceMilliSeconds
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
    
    func didSelectPlace(_ place: GeocodingResult) {
        placesSelectionUseCase.savePlaceId(place.id)
    }
}
