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
    
    var appDependencyContainer : AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer, navigationController: NavigationController = NavigationController()) {
        self.appDependencyContainer = appDependencyContainer
        self.navigationController = navigationController
    }
    
    typealias Route = PlacesRoute
    
    var navigationController : NavigationController
    @ViewBuilder
    func getView(for route : Route) -> some View {
        switch route {
        case .places:
            appDependencyContainer.getPlacesView()
        }
    }
    @ViewBuilder
    var rootView : some View {
        getView(for: .places)
    }
}
