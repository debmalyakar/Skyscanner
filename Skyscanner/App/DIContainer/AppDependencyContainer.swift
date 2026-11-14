//
//  AppDependencyContainer.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation
import SwiftData

class AppDependencyContainer {
    
    let swiftDataManager : SwiftDataManager
    
    var mainContext : ModelContext { swiftDataManager.mainContext }
    
    let databaseWorkerLazy : BackgroundInitStore<WeatherCacheStoreImpl>
    
    init (swiftDataManager : SwiftDataManager) {
        self.swiftDataManager = swiftDataManager
        let container = swiftDataManager.modelContainer
        self.databaseWorkerLazy = BackgroundInitStore(factory: {
            dispatchPrecondition(condition: .notOnQueue(.main))  // debug check: must be off main
            let store = WeatherCacheStoreImpl(modelContainer: container)
            print("created", ObjectIdentifier(store))
           return store
        })
    }
    
    func getPlacesSelectionUseCase() async -> PlacesSelectionUseCase {
        let placeSelectionRepo = await getPlaceSelectionRepository()
        return PlacesSelectionUseCaseImpl(placesSelectionRepository: placeSelectionRepo)
    }
    
    func getPlaceSelectionRepository() async -> some PlaceSelectionRepository {
        let placesSelectionStore = await databaseWorkerLazy.value()
        return PlaceSelectionRepoImpl(placeStore : placesSelectionStore)
    }
    
    func getPlacesViewModel() -> PlacesViewModel {
        return PlacesViewModel(geocodingFetchUseCase: getGeoCodingFetchUseCase(), asyncPlacesSelectionUseCaseFactory: { [unowned self] in
            return await getPlacesSelectionUseCase()
        }, asyncRefreshWeatherUseCaseFactory: { [unowned self] in
            return await getWeatherRefreshUseCase()
        })
    }
    
    func getWeatherRefreshUseCase() async -> some WeatherRefreshUseCase {
        return WeatherRefreshUseCaseImpl(placesRepo: await getSavedPlaceRepository(), weatherRepo: await getWeatherRepository(), maxAge: 2 * 60)
    }
    
    func getSavedPlaceRepository() async -> some SavedPlaceRepository {
        let dataSource = await databaseWorkerLazy.value()
        return SavedPlaceRepositoryImpl(local: dataSource)
    }
    
    func getWeatherRepository()async -> some WeatherRepository {
        let dataSource = await databaseWorkerLazy.value()
        return WeatherRepositoryImpl(remote: getWeatherRemoteDataSource(), local: dataSource, batchSize: 10)
    }
    
    func getWeatherRemoteDataSource() -> some WeatherFetchRemoteDataSource {
        return WeatherFetchRemoteDataSourceImpl(apiClient: getWeatherRemoteApiClient())
    }
    
    func getGeoCodingFetchUseCase() -> some GeocodingFetchUseCase {
        GeocodingFetchUseCaseImplementation(geocodingRepo: getGeoCodingRepository())
    }
    
    func getGeoCodingRemoteDataSource() -> GeocodingFetchRemoteDataSourceImpl {
        GeocodingFetchRemoteDataSourceImpl(apiClient: getGeoCodingApiClient())
    }
    
    func getGeoCodingRepository() -> some GeocodingRepository {
        GeocodingRepositoryImpl(dataSource: getGeoCodingRemoteDataSource())
    }
    
    func getWeatherRemoteApiClient() -> WeatherAPIClient {
        WeatherAPIClient()
    }
    
    func getGeoCodingApiClient() -> GeocodingAPIClient {
        GeocodingAPIClient()
    }
    
    func getPlacesView() -> PlacesView {
        PlacesView(viewModel: getPlacesViewModel())
    }
}
