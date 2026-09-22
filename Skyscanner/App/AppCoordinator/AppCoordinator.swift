//
//  AppCoordinator.swift
//  Skyscanner
//
//  Created by debmalyakar on 19/09/26.
//

import Foundation
import SwiftUI

enum TabItem: Hashable {
    case today
    case forecast
    case conditions
    case places

    var title: String {
        switch self {
        case .today:    return "Today"
        case .forecast:    return "Forecast"
        case .conditions:   return "Conditions"
        case .places:   return "Places"
        }
    }
    
    var symbol: String {
        switch self {
        case .today:      return "sun.max"
        case .forecast:   return "calendar"
        case .conditions: return "square.grid.2x2"
        case .places:     return "mappin.and.ellipse"
        }
    }
}



@Observable
class AppCoordinator {
    
    let conditionsCoordinator : ConditionsCoordinator
    let placesCoordinator : PlacesCoordinator
    
    var appDependencyContainer : AppDependencyContainer
    
    init (appDependencyContainer : AppDependencyContainer) {
        self.conditionsCoordinator = ConditionsCoordinator(appDependencyContainer: appDependencyContainer)
        self.placesCoordinator = PlacesCoordinator(appDependencyContainer: appDependencyContainer)
        self.appDependencyContainer = appDependencyContainer
    }
    
    var tabBarItems : [TabItem] = [.today , .forecast , .conditions , .places]
    var selectedTab : TabItem = .today
}

@Observable
class NavigationController {
    var navPath : NavigationPath = NavigationPath()
    
    func push<T : Hashable & Codable>(_ route : T) {
        navPath.append(route)
    }
    
    func pop() {
        guard !navPath.isEmpty else { return }
        navPath.removeLast()
    }
}

///  Common protocol for all coodinator classes.
protocol Coordinator : AnyObject {
    associatedtype Route : Hashable , Equatable
    associatedtype Destination : View
    associatedtype Root : View
    var navigationController : NavigationController { get set }
    @ViewBuilder
    func getView(for route : Route) -> Destination
    @ViewBuilder
    var rootView : Root { get }
}

/// generic coordinator view to be used with Coordinator
struct CoordinatorView <T : Coordinator>: View {
    var coordinator : T
    
    var body : some View {
        @Bindable var navigationController = coordinator.navigationController
        NavigationStack(path: $navigationController.navPath, root: {
            coordinator.rootView
        })
    }
}
