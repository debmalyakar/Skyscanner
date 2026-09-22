//
//  SkyscannerApp.swift
//  Skyscanner
//
//  Created by debmalyakar on 19/09/26.
//

import SwiftUI

@main
struct SkyscannerApp: App {
    let appDependencyContainer : AppDependencyContainer
    let coordinator : AppCoordinator
    init () {
        let appDependencyContainer = AppDependencyContainer()
        self.appDependencyContainer = appDependencyContainer
        self.coordinator = AppCoordinator(appDependencyContainer: appDependencyContainer)
        SkyTabBarAppearance.apply()
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
