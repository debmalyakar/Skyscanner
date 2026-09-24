//
//  PlacesViewModel.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation
import SwiftUI

enum SearchState {
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
    
    init(geocodingFetchUseCase: GeocodingFetchUseCase) {
        self.geocodingFetchUseCase = geocodingFetchUseCase
    }
    
    var trimmedQuery: String { query.trimmingCharacters(in: .whitespacesAndNewlines) }
    
    var searchState : SearchState = .idle

    func fetchGeocodingResponse(query: String , debounce : Bool = true) async  {
        let text = trimmedQuery
        guard text.count > 0 else {
            self.searchState = .idle
            return
        }
        if Task.isCancelled { return }
        
        if case .results = searchState {} else { searchState = .loading }
        if debounce {
            do { try await Task.sleep(nanoseconds: 300_000_000) } catch { return }
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
         self.searchState = .failed(error.localizedDescription)
        }
    }
}
