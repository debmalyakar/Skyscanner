//
//  SkyscannerApp.swift
//  Skyscanner
//
//  Created by debmalyakar on 19/09/26.
//

import SwiftUI

@main
struct SkyscannerApp: App {
    let coordinator = AppCoordinator()
    init () {
        SkyTabBarAppearance.apply()
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
