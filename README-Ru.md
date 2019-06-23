# Описание

Клиент для OpenWeather, написанный на Swift 5. Используемая архитектура – Clean Swift (VIP)

# Использование

1. Зарегистрироваться на https://openweathermap.org и получить App Key
2. Указать полученный ключ в AppPrivateData.openWeatherMapAPIKey
3. Запустить проект и нажать на "+" в навигационном баре
4. Ввести название города на английском для поиска. Нажать на ячейку с результатом поиска, чтобы добавить город в хранилище
5. Перейти в Cities, чтобы посмотреть прогноз и текущую температуру по сохраненным городам

# Скриншоты

<img src="http://www.picshare.ru/uploads/190618/t7UE6rp8DJ.png" width=375 height=667> <img src="http://www.picshare.ru/uploads/190618/Jo3GRmP1x7.png" width=375 height=667>
<img src="http://www.picshare.ru/uploads/190618/E7i10aE20i.png" width=375 height=667> <img src="http://www.picshare.ru/uploads/190618/0lxFD5ocv7.png" width=375 height=667>

# Архитектура

Проект написан на Clean Swift (VIP). Для генерации модулей используется шаблон [YARCH от Альфа-Банка](https://github.com/alfa-laboratory/YARCH), но проект не имеет полного соответствия предложенной схеме. Тем не менее, [эта статья](https://github.com/alfa-laboratory/YARCH/blob/master/GUIDE-rus.md) дает подробное представление о компонентах

## Пример use-case

Алгоритм выполнения поиска города по названию с примерами кода

### Builder - конфигурирование модуля

Каждый модуль наделен конфигуратором, при обращении к которому устанавливается начальное состояние модуля (например, состояние загрузки, или initial state с ID сущности, если модуль должен отобразить данные по какому-то объекту из хранилища)

let searchController = SearchBuilder().set(initialState: .loading).build()
navigationController?.pushViewController(searchController, animated: true)

Метод set устанавливает начальное состояние. А в методе build выполняется генерация контроллера и инъекция зависимых сущностей (презентера, интерактора). Затем, возвращается уже "собранный" контроллер, который достаточно просто отобразить

func build() -> UIViewController {
    let presenter = SearchPresenter()
    let interactor = SearchInteractor(presenter: presenter)

    let storyboard = UIStoryboard(name: "SearchStoryboard", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
    controller?.setup(interactor: interactor)

    presenter.viewController = controller

    return controller ?? UIViewController()
}

### DataFlow - описание use-cases

Request - запрос на поиск города по строке searchText
Response - в случае успеха, модель города, подходящая для сохранения в хранилище
ViewModel - модель ответа, подходящая для отображения во View. В простом случае - просто ViewModel. Согласно шаблону YARCH предлагается задавать состояние View Controller исходя из полученного ответа. Приемлемо ограничиваться просто описанием свойств ViewModel (или только result и error), особенно если в модуле множество кейсов, и каждому из них не следует брать на себя управление состоянием контроллера

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

### DataFlow - описание use-cases

### ViewController

При изменении текстового поля обращается к интерактору

func searchCity(text: String) {
    let request = Search.SearchCity.Request(searchText: text)
    interactor?.searchCity(request: request)
}

### Interactor

Обращается к провайдеру, а затем на основе его ответа подготавливает Response для передачи в презентер

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

### Provider

Провайдер занимается обращением к сервису или хранилищу, то есть принимает решение об источнике данных и выдает их в виде storage-модели

func searchCities(searchText: String, completion: @escaping ([CityStorageModel]?, SearchProviderError?) -> Void) {
    service.fetchCities(searchText: searchText) { (array, error) in
        if let error = error {
            completion(nil, .getItemsFailed(underlyingError: error))
        } else if let models = array {
            completion(models, nil)
        }
    }
}

### Service

Служит для общения с API-клиентом

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

### Presenter



# Содержание проекта

## Модули

### Поиск

При изменении текстового поля выполняется обращение к API. Полученный результат отображается в таблице. Найденый город можно сохранить в локальное хранилище, тапнув по ячейке

### Карта

### Сохраненные города

### Город / Прогноз

## Сетевой слой

Протокол APIClient описывает требования для клиента API. Таким образом, сервисный слой полностью отвязан от имплементации клиента. Могут быть подключены другие источники данных (в том числе локальные) 

## Хранилище

Общение с локальным хранилищем выполняется по протоколу StorageManagerProtocol, определяющим CRUD-методы, которые должен имплементировать клиент для хранилища. В данном примере используется Realm, взаимодействие с которым реализовано в классе RealmService

# TODO

# Рекомендуется к изучению

