//
//  Search module
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol SearchBusinessLogic {
    func searchCity(request: Search.SearchCity.Request)
    func checkCityExists(request: Search.CheckCityExistance.Request)
    func addCity(request: Search.AddCity.Request)
}

class SearchInteractor: SearchBusinessLogic {
    let presenter: SearchPresentationLogic
    let provider: SearchProviderProtocol

    init(presenter: SearchPresentationLogic, provider: SearchProviderProtocol = SearchProvider()) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func searchCity(request: Search.SearchCity.Request) {
        provider.searchCities(searchText: request.searchText) { (items, error) in
            let result: Search.SearchCityRequestResult
            
            if let items = items {
                result = .success(items)
            } else if let error = error {
                result = .failure(.searchCityFailed(message: error.localizedDescription))
            } else {
                result = .failure(.searchCityFailed(message: "Empty data fetched when search city"))
            }
            self.presenter.presentCities(response: Search.SearchCity.Response(result: result))
        }
    }
    
    func checkCityExists(request: Search.CheckCityExistance.Request) {
        provider.getCityFromStorage(id: request.model.id) { (item, error) in
            let result: Search.CheckCityExistanceRequestResult
            result = .success(storageModel: item)
            let viewModel = request.model
            self.presenter.presentCityExistance(response: Search.CheckCityExistance.Response(result: result, viewModel: viewModel))
        }
    }
    
    func addCity(request: Search.AddCity.Request) {
        let city = request.model
        let cityToAdd = CityStorageModel(id: city.id, name: city.name, latitude: city.latitude, longitude: city.longitude, temp: city.temp)
        
        provider.addCityIntoStorage(model: cityToAdd) { (error) in
            if let error = error {
                self.presenter.presentCityAddResult(response: Search.AddCity.Response(result: .failure(.addCityFailed(message: error.localizedDescription))))
            } else {
                self.presenter.presentCityAddResult(response: Search.AddCity.Response(result: .success))
            }
        }
    }
}
