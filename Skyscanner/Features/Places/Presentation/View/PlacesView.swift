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
            }
            .padding(AppPadding.padding8)

            
        }
    }
}

#Preview {
    AppDependencyContainer().getPlacesView()
}
