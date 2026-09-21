//
//  ConditionsCoordinator.swift
//  Skyscanner
//
//  Created by debmalyakar on 20/09/26.
//

import Foundation
import SwiftUI

enum ConditionsRoute : Hashable  , Equatable{
    case conditions
}

@Observable
class ConditionsCoordinator : Coordinator {
  
    typealias Route = ConditionsRoute
    var navigationController: NavigationController = NavigationController()
    
    @ViewBuilder
    func getView(for route : Route) -> some View {
        switch route {
        case .conditions:
             EmptyView()
        }
    }
    @ViewBuilder
    var rootView : some View {
        getView(for:.conditions)
            .navigationDestination(for: ConditionsRoute.self, destination: { [unowned self] route in
                self.getView(for: route)
        })
    }
    
    
}
