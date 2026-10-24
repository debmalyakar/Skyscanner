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

// MARK: - Manager

@MainActor
final class SwiftDataManager {
    let modelContainer: ModelContainer
    let mainContext: ModelContext

    init(inMemory: Bool = SwiftDataManager.isRunningTests) {
        let configuration: ModelConfiguration
        if inMemory {
            configuration = ModelConfiguration(schema: SkyscannerSchema.all, isStoredInMemoryOnly: true)
        } else {
            let storeURL = URL.documentsDirectory.appendingPathComponent("AppDatabase.sqlite")
            configuration = ModelConfiguration(schema: SkyscannerSchema.all, url: storeURL)
        }

        do {
            modelContainer = try ModelContainer(for: SkyscannerSchema.all, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        mainContext = modelContainer.mainContext
    }

    nonisolated static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
