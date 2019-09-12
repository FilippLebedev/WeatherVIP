//
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol CityProviderProtocol {
    func getWeather(cityId: UniqueIdentifier, completion: @escaping (WeatherStorageModel?, CityProviderError?) -> Void)
}

enum CityProviderError: Error {
    case getItemsFailed(underlyingError: Error)
}

struct CityProvider: CityProviderProtocol {
    let dataStore: CityDataStore
    let service: CityServiceProtocol

    init(dataStore: CityDataStore = CityDataStore(), service: CityServiceProtocol = CityService()) {
        self.dataStore = dataStore
        self.service = service
    }

    func getWeather(cityId: UniqueIdentifier, completion: @escaping (WeatherStorageModel?, CityProviderError?) -> Void) {
        service.fetchWeather(cityId: cityId) { (item, error) in
            if let error = error {
                completion(nil, .getItemsFailed(underlyingError: error))
            } else {
                completion(item, nil)
            }
        }
    }
}
