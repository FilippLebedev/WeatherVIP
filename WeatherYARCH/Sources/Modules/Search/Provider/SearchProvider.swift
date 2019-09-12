//
//  Created by Filipp Lebedev on 05/05/2019.
//

import RealmSwift

protocol SearchProviderProtocol {
    func searchCities(searchText: String, completion: @escaping ([CityStorageModel]?, SearchProviderError?) -> Void)
    func getCityFromStorage(id: UniqueIdentifier, completion: @escaping (CityStorageModel?, SearchProviderError?) -> Void)
    func addCityIntoStorage(model: CityStorageModel, completion: @escaping (SearchProviderError?) -> Void)
}

enum SearchProviderError: Error {
    case getItemsFailed(underlyingError: Error)
    case getCityFromStorageFailed
    case addCityIntoStorageFailed
}

struct SearchProvider: SearchProviderProtocol {
    let dataStore: SearchDataStore
    let service: SearchServiceProtocol

    init(dataStore: SearchDataStore = SearchDataStore(), service: SearchServiceProtocol = SearchService()) {
        self.dataStore = dataStore
        self.service = service
    }

    func searchCities(searchText: String, completion: @escaping ([CityStorageModel]?, SearchProviderError?) -> Void) {
        service.fetchCities(searchText: searchText) { (array, error) in
            if let error = error {
                completion(nil, .getItemsFailed(underlyingError: error))
            } else if let models = array {
                completion(models, nil)
            }
        }
    }
    
    func getCityFromStorage(id: UniqueIdentifier, completion: @escaping (CityStorageModel?, SearchProviderError?) -> Void) {
        dataStore.cityById(id) { (item) in
            if let city = item {
                completion(city, nil)
            } else {
                completion(nil, .getCityFromStorageFailed)
            }
        }
    }
    
    func addCityIntoStorage(model: CityStorageModel, completion: @escaping (SearchProviderError?) -> Void) {
        dataStore.addCity(model) { (success) in
            if success {
                completion(nil)
            } else {
                completion(.addCityIntoStorageFailed)
            }
        }
    }
}
