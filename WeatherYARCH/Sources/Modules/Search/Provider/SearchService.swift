//
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol SearchServiceProtocol {
    func fetchCities(searchText: String, completion: @escaping ([CityStorageModel]?, Error?) -> Void)
}

class SearchService: AbstractService, SearchServiceProtocol {

    func fetchCities(searchText: String, completion: @escaping ([CityStorageModel]?, Error?) -> Void) {
        apiClient.cancelAllRequests()
        
        let request = apiClient.request(for: SearchCityRequest(searchText: searchText))
        
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
