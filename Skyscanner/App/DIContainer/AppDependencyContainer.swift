//
//  AppDependencyContainer.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import Foundation

class AppDependencyContainer {
    func getPlacesViewModel() -> PlacesViewModel {
        return PlacesViewModel(geocodingFetchUseCase: getGeoCodingFetchUseCase())
    }
    
    func getGeoCodingFetchUseCase() -> GeocodingFetchUseCase {
        
        GeocodingFetchUseCase(goecodingRepo: getGeoCodingRepository())
    }
    
    func getGeoCodingRemoteDataSource() -> GeocodingFetchRemoteDataSourceImpl {
        GeocodingFetchRemoteDataSourceImpl(apiClient: getGeoCodingApiClient())
    }
    
    func getGeoCodingRepository() -> GeocodingRepositoryImpl {
        GeocodingRepositoryImpl(dataSource: getGeoCodingRemoteDataSource())
    }
    
    func getGeoCodingApiClient() -> GeocodingAPIClient {
        GeocodingAPIClient()
    }
    
    func getPlacesView() -> PlacesView {
        PlacesView(viewModel: getPlacesViewModel())
    }
}
