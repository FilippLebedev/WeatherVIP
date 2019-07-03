# ⛅ Weather VIP ⛅

[🇬🇧 ОПИСАНИЕ НА РУССКОМ 🇬🇧](README-Ru.md)

OpenWeather client written on Swift 5. Clean Swift (VIP) architecture used

<img src="http://www.picshare.ru/uploads/190618/t7UE6rp8DJ.png" width=375 height=667> <img src="http://www.picshare.ru/uploads/190618/Jo3GRmP1x7.png" width=375 height=667>
<img src="http://www.picshare.ru/uploads/190618/E7i10aE20i.png" width=375 height=667> <img src="http://www.picshare.ru/uploads/190618/0lxFD5ocv7.png" width=375 height=667>

# How to use?

1. Register on https://openweathermap.org and receive App Key
2. Specify received key in AppPrivateData.openWeatherMapAPIKey
3. Build the project and tap "+" in navigation bar
4. Enter the city to search (in English). Press a cell with search result to add city into storage
5. Pass into Cities to watch forecast and current temperature for saved cities

# Architecture

The project is constructed on Clean Swift (VIP). [YARCH from Alfa-Bank] (https://github.com/alfa-laboratory/YARCH) template is used for module generation, but the project has no full compliance to the offered scheme. For example, Storyboards are using, and View is not separated from ViewController. Nevertheless, [this article] (https://github.com/alfa-laboratory/YARCH/blob/master/GUIDE.md) gives a detailed idea of components

## Use-case example

Algorithm of city searching by the name with code examples

### Builder - configuration of the module

Each module has configurator at the appeal to which the initial state of the module been set (for example, loading; or initial state with the identifier of object if module has to display data of specified object)

```swift
let searchController = SearchBuilder().set(initialState: .loading).build()
navigationController?.pushViewController(searchController, animated: true)
```

* set(initialState) - defines start state
* build() - controller initialization and an injection of dependent entities (presenter, interactor) is carried out. Then it is enough just to display assembled controller

```swift
func build() -> UIViewController {
    let presenter = SearchPresenter()
    let interactor = SearchInteractor(presenter: presenter)

    let storyboard = UIStoryboard(name: "SearchStoryboard", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
    controller?.setup(interactor: interactor)

    presenter.viewController = controller

    return controller ?? UIViewController()
}
```

### DataFlow - the description of use-cases

Request - a request of city searching by searchText string

Response - the city model suitable for signing up in storage (if success)

ViewModel - the answer model suitable for display in View. According to the YARCH template it is offered to set View Controller state proceeding from the received answer. But it is acceptable for this struct just to be the description of ViewModel properties (or only result and error), especially if there is a lot of cases, and each of them should not undertake state management of the controller

```swift
enum SearchCity {
    struct Request {
        let searchText: String
    }

    struct Response {
        var result: SearchCityRequestResult
    }

    struct ViewModel {
        var state: ViewControllerState
    }
}

enum SearchCityRequestResult {
    case failure(SearchError)
    case success([CityStorageModel])
}

enum ViewControllerState {
    case initial
    case loading
    case result([SearchCityModel])
    case emptyResult
    case error(message: String)
}
```

### ViewController

Calls interactor when search text field changed

```swift
func searchCity(text: String) {
    let request = Search.SearchCity.Request(searchText: text)
    interactor?.searchCity(request: request)
}
```

### Interactor

Addresses provider and then prepares Response for transfer to presenter

```swift
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
```

### Provider

Provider appeals to service or storage, requests data and return it as storage-model

```swift
func searchCities(searchText: String, completion: @escaping ([CityStorageModel]?, SearchProviderError?) -> Void) {
    service.fetchCities(searchText: searchText) { (array, error) in
        if let error = error {
            completion(nil, .getItemsFailed(underlyingError: error))
        } else if let models = array {
            completion(models, nil)
        }
    }
}
```

### Service

Serves for communication with API client

```swift
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
```

Note. In the apiClient.cancelAllRequests() method canceling of all current requests to API is carried out. As at each change in a text box the request to API is generated. It is necessary for preventing race condition of search results - so the result  for the relevant search text only will come back. In real projects it is unacceptable to reset all requests at the same time therefore there has to be an opportunity to cancel a specific request. Or it is necessary not to cancel requests and just to check on relevance of data retrieveds on View

### Presenter

When search results are received interactor reports about it to presenter, transferring data in Response struct which interactor will transform to ViewModel at last to display in View

```swift
func presentCities(response: Search.SearchCity.Response) {
    var viewModel: Search.SearchCity.ViewModel

    switch response.result {
    case let .failure(error):
        viewModel = Search.SearchCity.ViewModel(state: .error(message: error.localizedDescription))
    case let .success(result):
        if result.isEmpty {
            viewModel = Search.SearchCity.ViewModel(state: .emptyResult)
        } else {
            let cities = result.map { SearchCityModel(id: $0.id, name: $0.name, latitude: $0.latitude, longitude: $0.longitude, temp: $0.temp) }
            viewModel = Search.SearchCity.ViewModel(state: .result(cities))
        }
    }

    viewController?.displayCities(viewModel: viewModel)
}
```

### DataStore

Not involved for this case. It is used for interaction with local storage

# Contents of the project

## Modules

### Search

API call is carried out at text field change. The received result is displayed in the table. The found city can be saved in local storage by cell tapping

### Map

Saved cities are displayed on map with current temperature indicator

### Saved cities

The list of cities from storage. The cities can be deleted by swipe

### City / Forecast

The current temperature in the selected city. And a submodule with the table of a weather forecast for 5 days

## Network layer

The APIClient protocol describes requirements for the client of API. Thus, the service layer is completely unrelated from client implementation. Other data sources can be connected (including local)

## Storage

Communication with local storage is carried out under the StorageManagerProtocol protocol that definines CRUD methods which the storage client should implement. Realm is used in this example. Interaction with it is implemented in RealmService class

# TODO / Bugs / How to improve the project?

* Increase test coverage
* Introduce new layer of model (to process responses from specific APIs) and adapter for storage-model which is completely tied on Realm at present. And also unchangeable CodingKeys are specified in it that makes model related with certain API
* Error processing and output
* Weather on the card is not always displayed after receiving

# Useful

* [YARCH](https://github.com/alfa-laboratory/YARCH)
* [Realm documentation](https://realm.io/docs/swift/latest/)
* [CodableAlamofire](https://github.com/Otbivnoe/CodableAlamofire)
