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
    
    func getGeoCodingFetchUseCase() -> some GeocodingFetchUseCaseProtocol {
        
        GeocodingFetchUseCase(goecodingRepo: getGeoCodingRepository())
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
