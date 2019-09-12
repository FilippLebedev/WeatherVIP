//
//  Map module
//  Created by Filipp Lebedev on 05/05/2019.
//

enum Map {
    
    // Get cities
    
    enum ShowCities {
        struct Request {
        }

        struct Response {
            var result: ShowCitiesResult
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }

    enum ShowCitiesResult {
        case failure(MapError)
        case success([CityStorageModel])
    }

    enum ViewControllerState {
        case loading
        case result([MapCityModel])
        case emptyResult
        case error(message: String)
    }
    
    // Get city weather
    
    enum GetWeather {
        struct Request {
            var cityId: UniqueIdentifier
        }
        
        struct Response {
            var result: GetWeatherResult
        }
        
        struct ViewModel {
            var model: MapWeatherModel
        }
    }
    
    enum GetWeatherResult {
        case failure(MapError)
        case success(WeatherStorageModel)
    }
    
    // Common

    enum MapError: Error {
        case getCitiesFailed(message: String)
        case getWeatherFailed(message: String)
    }
}
