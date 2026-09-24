//
//  PlacesSearchResultView.swift
//  Skyscanner
//
//  Created by debmalyakar on 24/09/26.
//

import SwiftUI

struct PlacesSearchResultView: View {
    var searchBarState : SearchState
    var query : String
    var body: some View {
        ZStack {
            Color.ink
            
            switch searchBarState {
                case .loading:
                ProgressView()
                    .plainRow()
            case .results(let searchResults) :
                List(searchResults) { result in
                    PlacesSearchResultRow(result: result, isSaved: false, onAdd: {
                        
                    })
                    .plainRow(horizontal: 5)
                }
                .scrollContentBackground(.hidden)
                
                case .empty:
                message("No places found for “\(query)”.")

                
                case .failed:
                message("Failed to load results")

                
                case .idle:
                message("Keep typing to search…")

            }
        }
    }
    
    private func message(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15))
            .foregroundStyle(Color.white.opacity(0.88))
            .frame(maxWidth: .infinity, minHeight: 64)
            .plainRow()
    }
}

#Preview {
    PlacesSearchResultView(searchBarState: .results([GeocodingResult(id: 1, name: "Kolkata", latitude: 23.44, longitude: 23.33, country: "India", admin1: "", timezone: "IST")]), query: "Kolkata")
}
