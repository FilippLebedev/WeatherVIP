//
//  Created by Filipp Levedev on 29/05/2019.
//

protocol CityForecastProviderProtocol {
    func getForecast(cityId: UniqueIdentifier, completion: @escaping ([ForecastStorageModel]?, CityForecastProviderError?) -> Void)
}

enum CityForecastProviderError: Error {
    case getItemsFailed(underlyingError: Error)
}

struct CityForecastProvider: CityForecastProviderProtocol {
    let dataStore: CityForecastDataStore
    let service: CityForecastServiceProtocol

    init(dataStore: CityForecastDataStore = CityForecastDataStore(), service: CityForecastServiceProtocol = CityForecastService()) {
        self.dataStore = dataStore
        self.service = service
    }

    func getForecast(cityId: UniqueIdentifier, completion: @escaping ([ForecastStorageModel]?, CityForecastProviderError?) -> Void) {
        service.fetchForecasts(cityId: cityId) { (array, error) in
            if let error = error {
                completion(nil, .getItemsFailed(underlyingError: error))
            } else if let models = array {
                completion(models, nil)
            }
        }
    }
}
