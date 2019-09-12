//
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol CityServiceProtocol {
    func fetchWeather(cityId: UniqueIdentifier, completion: @escaping (WeatherStorageModel?, Error?) -> Void)
}

class CityService: AbstractService, CityServiceProtocol {

    func fetchWeather(cityId: UniqueIdentifier, completion: @escaping (WeatherStorageModel?, Error?) -> Void) {
        let request = apiClient.request(for: GetCityWeatherRequest(cityId: cityId))
        
        apiClient.send(request) { response in
            switch response {
            case let .failure(error):
                completion(nil, error)
            case let .success(result):
                completion(result, nil)
            }
        }
    }
}
