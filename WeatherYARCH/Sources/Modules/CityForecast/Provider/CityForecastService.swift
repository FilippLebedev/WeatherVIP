//
//  Created by Filipp Levedev on 29/05/2019.
//

protocol CityForecastServiceProtocol {
    func fetchForecasts(cityId: UniqueIdentifier, completion: @escaping ([ForecastStorageModel]?, Error?) -> Void)
}

class CityForecastService: AbstractService, CityForecastServiceProtocol {

    func fetchForecasts(cityId: UniqueIdentifier, completion: @escaping ([ForecastStorageModel]?, Error?) -> Void) {
        let request = apiClient.request(for: GetCityForecastRequest(cityId: cityId))
            
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
