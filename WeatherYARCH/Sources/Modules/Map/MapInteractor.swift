//
//  Map module
//  Created by Filipp Lebedev on 05/05/2019.
//

protocol MapBusinessLogic {
    func setupCitiesObserving(request: Map.ShowCities.Request)
    func getWeatherForCity(request: Map.GetWeather.Request)
}

class MapInteractor: MapBusinessLogic {
    let presenter: MapPresentationLogic
    var provider: MapProviderProtocol

    init(presenter: MapPresentationLogic, provider: MapProviderProtocol = MapProvider()) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func setupCitiesObserving(request: Map.ShowCities.Request) {
        provider.setupCitiesObserving { (items, error) in
            if let items = items {
                let response = Map.ShowCities.Response(result: .success(items))
                self.presenter.presentCities(response: response)
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getWeatherForCity(request: Map.GetWeather.Request) {
        provider.getWeatherForCity(id: request.cityId) { (item, error) in
            if let item = item {
                let response = Map.GetWeather.Response(result: .success(item))
                self.presenter.presentWeatherForCity(response: response)
            }
        }
    }
}
