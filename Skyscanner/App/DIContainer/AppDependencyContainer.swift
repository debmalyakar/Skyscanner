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
    
    let databaseWorkerLazy : BackgroundInitStore<WeatherCacheStore>
    
    init (swiftDataManager : SwiftDataManager) {
        self.swiftDataManager = swiftDataManager
        self.databaseWorkerLazy = BackgroundInitStore(factory: {
            WeatherCacheStoreImpl(modelContainer: swiftDataManager.modelContainer)
        })
    }
    
    func getPlacesSelectionUseCase() -> PlacesSelectionUseCase {
        PlacesSelectionUseCaseImpl(placesSelectionRepository: getPlaceSelectionRepository())
    }
    
    func getPlaceSelectionRepository() -> some PlaceSelectionRepository {
        PlaceSelectionRepoImpl()
    }
    
    func getPlacesViewModel() -> PlacesViewModel {
        return PlacesViewModel(geocodingFetchUseCase: getGeoCodingFetchUseCase(), placesSelectionUseCase: getPlacesSelectionUseCase())
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
    
    func getGeoCodingApiClient() -> GeocodingAPIClient {
        GeocodingAPIClient()
    }
    
    func getPlacesView() -> PlacesView {
        PlacesView(viewModel: getPlacesViewModel())
    }
}
