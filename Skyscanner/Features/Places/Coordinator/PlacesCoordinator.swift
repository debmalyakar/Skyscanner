//
//  PlacesCoordinator.swift
//  Skyscanner
//
//  Created by debmalyakar on 20/09/26.
//

import Foundation
import SwiftUI

enum PlacesRoute : Hashable , Equatable {
    case places
}

@Observable
class PlacesCoordinator : Coordinator {
    
    typealias Route = PlacesRoute
    
    var navigationController : NavigationController = NavigationController()
    @ViewBuilder
    func getView(for route : Route) -> some View {
        switch route {
        case .places:
             EmptyView()
        }
    }
    @ViewBuilder
    var rootView : some View {
        getView(for: .places)
    }
}
