//
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol MapProviderProtocol {
    func setupCitiesObserving(completion: @escaping ([CityStorageModel]?, MapProviderError?) -> Void)
    func getWeatherForCity(id: UniqueIdentifier, completion: @escaping (WeatherStorageModel?, MapProviderError?) -> Void)
}

enum MapProviderError: Error {
    case citiesObservingFailed(underlyingError: Error)
    case getWeatherFailed(underlyingError: Error)
}

struct MapProvider: MapProviderProtocol {
    let dataStore: MapDataStore
    let service: MapServiceProtocol

    init(dataStore: MapDataStore = MapDataStore(), service: MapServiceProtocol = MapService()) {
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
    
    func getWeatherForCity(id: UniqueIdentifier, completion: @escaping (WeatherStorageModel?, MapProviderError?) -> Void) {
        service.fetchCityWeather(cityId: id) { (item, error) in
            if let error = error {
                completion(nil, .getWeatherFailed(underlyingError: error))
            } else {
                completion(item, nil)
            }
        }
    }
}
