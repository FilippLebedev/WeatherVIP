# ⛅ Weather VIP ⛅

[🇬🇧 ОПИСАНИЕ НА РУССКОМ 🇬🇧](README-Ru.md)

OpenWeather client written on Swift 5. Clean Swift (VIP) architecture used

<img src="http://www.picshare.ru/uploads/190618/t7UE6rp8DJ.png" width=375 height=667> <img src="http://www.picshare.ru/uploads/190618/Jo3GRmP1x7.png" width=375 height=667>
<img src="http://www.picshare.ru/uploads/190618/E7i10aE20i.png" width=375 height=667> <img src="http://www.picshare.ru/uploads/190618/0lxFD5ocv7.png" width=375 height=667>

# Using

1. Register on https://openweathermap.org and receive App Key
2. Specify received key in AppPrivateData.openWeatherMapAPIKey
3. Build the project and press on "+" in navigation bar
4. Enter the name of the city in English for search. Press a cell with search result to add the city into storage
5. Pass into Cities to see forecast and current temperature for saved cities

# Architecture

The project is constructed on Clean Swift (VIP). For generation of modules the template [YARCH from Alfa-Bank] is used (https://github.com/alfa-laboratory/YARCH), but the project has no full compliance to the offered scheme. For example, in this project Storyboard, and View unseparably from ViewController are used. Nevertheless, [this article] (https://github.com/alfa-laboratory/YARCH/blob/master/GUIDE.md) gives a detailed idea of components

## Example of use-case

Algorithm of city searching by the name with examples of the code

### Builder - configuration of the module

Each module has configurator at the appeal to which the initial state of the module been set (for example, loading; or initial state with the identifier of object if the module has to display data on any object)

```swift
let searchController = SearchBuilder().set(initialState: .loading).build()
navigationController?.pushViewController(searchController, animated: true)
```

Метод set устанавливает начальное состояние. А в методе build выполняется инициализация контроллера и инъекция зависимых сущностей (презентера, интерактора). Затем возвращается уже "собранный" контроллер, который достаточно только отобразить

Set method sets start state. And in the build method initialization of the controller and an injection of dependent entities is carried out (a prezenter, an interaktor). Then already "assembled" controller which is only enough to be displayed returns

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

### DataFlow - описание use-cases

Request - запрос на поиск города по строке searchText

Response - в случае успеха, модель города, пригодная для записи в хранилище

ViewModel - модель ответа, подходящая для отображения во View. В простом случае - просто ViewModel. Согласно шаблону YARCH предлагается задавать состояние View Controller исходя из полученного ответа. Приемлемо ограничиваться описанием свойств ViewModel (или только result и error), особенно если в модуле множество кейсов, и каждому из них не следует брать на себя управление состоянием контроллера

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

При изменении текстового поля обращается к интерактору

```swift
func searchCity(text: String) {
    let request = Search.SearchCity.Request(searchText: text)
    interactor?.searchCity(request: request)
}
```

### Interactor

Обращается к провайдеру, а затем на основе его ответа подготавливает Response для передачи в презентер

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

Провайдер занимается обращением к сервису или хранилищу, запрашивает данные и выдает их в виде storage-модели

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

Служит для общения с API-клиентом

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

Примечание. В методе apiClient.cancelAllRequests() выполняется отмена всех текущих запросов к API. Поскольку при каждом изменении в текстовом поле генерируется запрос к API. Это нужно, чтобы результаты поиска друг-друга не обгоняли и всегда приходил результат только по актуальному тексту в SearchBar. В реальном проекте неприемлемо сбрасывать одновременно все запросы, поэтому должна быть возможность отменять конкретный запрос. Или же надо не отменять реквесты, а просто выполнять проверку на актуальность полученных данных на слое View

### Presenter

Когда результаты поиска получены, интерактор сообщает об этом презентеру, передавая данные в структуре Response, которые интерактор преобразует во ViewModel, чтобы наконец отобразить во View

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

Не задействован в данном кейсе. Используется для взаимодействия с локальным хранилищем

# Содержание проекта

## Модули

### Поиск

При изменении текстового поля выполняется обращение к API. Полученный результат отображается в таблице. Найденый город можно сохранить в локальное хранилище, тапнув по ячейке

### Карта

Сохраненные города отображаются на карте с указанием текущей температуры

### Сохраненные города

Список городов в хранилище. Города можно удалять свайпом влево

### Город / Прогноз

Текущая температура в выбранном городе и подмодуль с таблицей прогноза погоды на 5 дней

## Сетевой слой

Протокол APIClient описывает требования для клиента API. Таким образом, сервисный слой полностью отвязан от имплементации клиента. Могут быть подключены другие источники данных (в том числе локальные) 

## Хранилище

Общение с локальным хранилищем выполняется по протоколу StorageManagerProtocol, определяющим CRUD-методы, которые должен имплементировать клиент для хранилища. В данном примере используется Realm, взаимодействие с которым реализовано в классе RealmService

# TODO / Баги / Как улучшить проект?

* Покрытие тестами
* Введение нового слоя модели (для обработки ответа конкретных API) и адаптера для storage-модели, которая в данный момент полностью завязана на Realm, а также в ней прописаны неизменяемые CodingKeys, что делает ее связанной с определенным API
* Обработка и вывод ошибок
* Погода на карте не всегда выводится после получения

# Полезное

* [Clean swift архитектура как альтернатива VIPER](https://habr.com/ru/post/415725/)
* [YARCH](https://github.com/alfa-laboratory/YARCH)
* [Документация Realm](https://realm.io/docs/swift/latest/)
* [CodableAlamofire](https://github.com/Otbivnoe/CodableAlamofire)
