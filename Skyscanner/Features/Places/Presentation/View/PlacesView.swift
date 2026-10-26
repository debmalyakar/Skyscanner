//
//  PlacesView.swift
//  Skyscanner
//
//  Created by debmalyakar on 21/09/26.
//

import SwiftUI

struct PlacesView: View {
    @State var viewModel: PlacesViewModel
    var body: some View {
        ZStack {
            Color.ink.ignoresSafeArea(edges: .all)
            VStack {
                PlacesHeader(heading: "Places")
                SearchBar(query: $viewModel.query)
                   
                PlacesSearchResultView(searchBarState: viewModel.searchState, query: viewModel.trimmedQuery, onAdd: { geocodingResult in
                    viewModel.didSelectPlace(geocodingResult)
                })
                .equatable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .padding(AppPadding.padding8)
            .task(id : viewModel.query) {
                await viewModel.fetchGeocodingResponse(query: viewModel.query)
            }

            
        }
    }
}

#Preview {
    AppDependencyContainer(swiftDataManager: SwiftDataManager()).getPlacesView()
}
