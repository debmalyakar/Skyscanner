//
//  SwiftDataManager.swift
//  Skyscanner
//
//  Created by debmalyakar on 16/10/26.
//

import Foundation
import SwiftData

// MARK: - Schema

enum SkyscannerSchema {
    static let all = Schema([
        SavedPlace.self,
        CurrentWeather.self,
        DailyForecastEntry.self,
        HourlyForecastEntry.self
    ])
}

class SwiftDataManager {
    let modelContainer : ModelContainer
    let mainContext : ModelContext
    
    init() {
        let storeURL = URL.documentsDirectory.appendingPathComponent("AppDatabase.sqlite")
        let configuration = ModelConfiguration(schema : SkyscannerSchema.all , url: storeURL , allowsSave: false)
        self.modelContainer = try! ModelContainer(configurations: configuration)
        self.mainContext = modelContainer.mainContext
    }
}
