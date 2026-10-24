//
//  AppDependencyContainer.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation
import SwiftData

class AppDependencyContainer {
    
    let swiftDataManager : SwiftDataManager = SwiftDataManager()
    
    var mainContext : ModelContext { swiftDataManager.mainContext }
    
    init () {
        
    }
    
    func getPlacesViewModel() -> PlacesViewModel {
        return PlacesViewModel(geocodingFetchUseCase: getGeoCodingFetchUseCase())
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
