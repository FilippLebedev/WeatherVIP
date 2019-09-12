//
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol CitiesProviderProtocol {
    func setupCitiesObserving(completion: @escaping ([CityStorageModel]?, MapProviderError?) -> Void)
    func deleteCity(id: UniqueIdentifier, completion: @escaping (_ success: Bool, _ error: CitiesProviderError?) -> Void)
}

enum CitiesProviderError: Error {
    case getItemsFailed(underlyingError: Error)
    case deleteCityFailed
}

struct CitiesProvider: CitiesProviderProtocol {
    let dataStore: CitiesDataStore
    let service: CitiesServiceProtocol

    init(dataStore: CitiesDataStore = CitiesDataStore(), service: CitiesServiceProtocol = CitiesService()) {
        self.dataStore = dataStore
        self.service = service
    }

    func setupCitiesObserving(completion: @escaping ([CityStorageModel]?, MapProviderError?) -> Void) {
        dataStore.setupCityObserving() { (items, error) in
            if let items = items {
                completion(items, nil)
            } else if let error = error {
                completion(nil, .citiesObservingFailed(underlyingError: error))
            }
        }
    }
    
    func deleteCity(id: UniqueIdentifier, completion: @escaping (_ success: Bool, _ error: CitiesProviderError?) -> Void) {
        dataStore.deleteCity(id: id) { (success) in
            if success {
                completion(true, nil)
            } else {
                completion(false, .deleteCityFailed)
            }
        }
    }
}
