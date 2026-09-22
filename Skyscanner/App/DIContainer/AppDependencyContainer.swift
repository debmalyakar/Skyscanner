//
//  AppDependencyContainer.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation

class AppDependencyContainer {
    func getPlacesViewModel() -> PlacesViewModel {
        return PlacesViewModel()
    }
    
    func getPlacesView() -> PlacesView {
        PlacesView(viewModel: getPlacesViewModel())
    }
}
