//
//  Cities module
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol CitiesBusinessLogic {
    func setupCitiesObserving(request: Cities.ShowCities.Request)
    func deleteCity(request: Cities.DeleteCity.Request)
}

class CitiesInteractor: CitiesBusinessLogic {
    let presenter: CitiesPresentationLogic
    var provider: CitiesProviderProtocol

    init(presenter: CitiesPresentationLogic, provider: CitiesProviderProtocol = CitiesProvider()) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func setupCitiesObserving(request: Cities.ShowCities.Request) {
        provider.setupCitiesObserving { [weak self] (items, error) in
            if let items = items {
                let response = Cities.ShowCities.Response(result: .success(items))
                self?.presenter.presentCities(response: response)
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteCity(request: Cities.DeleteCity.Request) {
        provider.deleteCity(id: request.cityId) { [weak self] (success, error) in }
    }
}
