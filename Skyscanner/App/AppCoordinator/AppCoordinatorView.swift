//
//  AppCoordinatorView.swift
//  Skyscanner
//
//  Created by debmalyakar on 20/09/26.
//

import SwiftUI

struct AppCoordinatorView: View {
    let coordinator : AppCoordinator
    
    var body: some View {
        @Bindable var coordinator = coordinator
        TabView (selection: $coordinator.selectedTab, content: {
            
            Tab(TabItem.today.title, systemImage: TabItem.today.symbol, value: TabItem.today) {
                getTodayView(tabItem: .today)
            }
                
            Tab(TabItem.forecast.title, systemImage: TabItem.forecast.symbol, value: TabItem.forecast) {
                getForeCastView(tabItem: .forecast)
            }
            
            Tab(TabItem.conditions.title, systemImage: TabItem.conditions.symbol, value: TabItem.conditions) {
                getConditionsView(tabItem: .conditions)
            }
            
            Tab(TabItem.places.title, systemImage: TabItem.places.symbol, value: TabItem.places) {
                getPlacesView(tabItem: .places)
            }
        })
        .tint(SkyTabPalette.selected)
        
    }
}

extension AppCoordinatorView {
    @ViewBuilder func getConditionsView(tabItem : TabItem) -> some View {
        ZStack {
            Color.midnight
                .ignoresSafeArea(edges: .all)
            CoordinatorView(coordinator: coordinator.conditionsCoordinator)
                .tag(tabItem)
        }
        
    }
    
    @ViewBuilder func getForeCastView(tabItem : TabItem) -> some View {
        EmptyView()
            .tag(tabItem)
    }
    
    @ViewBuilder func getPlacesView(tabItem : TabItem) -> some View {
        CoordinatorView(coordinator: coordinator.placesCoordinator).tag(tabItem)
    }
    
    @ViewBuilder func getTodayView(tabItem : TabItem) -> some View {
        EmptyView()
            .tag(tabItem)
    }
}

#Preview {
    AppCoordinatorView(coordinator: AppCoordinator(appDependencyContainer: AppDependencyContainer()))
}
