//
//  City module
//  Created by Filipp Lebedev on 05/05/2019.
//

enum City {
    
    enum ShowWeather {
        struct Request {
            var cityId: UniqueIdentifier
        }

        struct Response {
            var result: ShowWeatherRequestResult
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum ShowWeatherRequestResult {
        case failure(CityError)
        case success(WeatherStorageModel)
    }
    
    enum ViewControllerState {
        case initial(id: UniqueIdentifier)
        case loading
        case result(CityWeatherModel)
        case emptyResult
        case error(message: String)
    }
    
    enum CityError: Error {
        case getWeatherFailed(message: String)
    }
}
