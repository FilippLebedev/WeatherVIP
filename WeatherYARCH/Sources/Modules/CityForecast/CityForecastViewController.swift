//
//  CityForecast module
//  Created by Filipp Levedev on 29/05/2019.
//

import UIKit

protocol CityForecastDisplayLogic: class {
    func displayForecast(viewModel: CityForecast.ShowForecast.ViewModel)
}

class CityForecastViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: CityForecastBusinessLogic?
    var state: CityForecast.ViewControllerState = .loading
    
    var tableDataSource: CityForecastTableDataSource = CityForecastTableDataSource()
    var tableStateManager: TableStateManager = CityForecastTableStateManager()

    func setup(interactor: CityForecastBusinessLogic, initialState: CityForecast.ViewControllerState = .loading) {
        self.interactor = interactor
        self.state = initialState
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tableDataSource
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableStateManager.tableView = tableView
        
        switch state {
        case let .initial(id):
            fetchForecast(cityId: id)
        default:
            break
        }
    }

    private func updateForecast(model: [CityForecastModel]) {
        tableDataSource.representableViewModels = model
        tableView.reloadData()
    }
    
    private func fetchForecast(cityId: UniqueIdentifier) {
        display(newState: .loading)
        interactor?.fetchForecast(request: CityForecast.ShowForecast.Request(cityId: cityId))
    }
}

extension CityForecastViewController: CityForecastDisplayLogic {
    func displayForecast(viewModel: CityForecast.ShowForecast.ViewModel) {
        display(newState: viewModel.state)
    }

    func display(newState: CityForecast.ViewControllerState) {
        state = newState
        switch state {
        case let .initial(cityId):
            tableStateManager.setLoadingState()
        case .loading:
            tableStateManager.setLoadingState()
        case let .error(message):
            print("error \(message)")
        case let .result(items):
            updateForecast(model: items)
            tableStateManager.setResultState()
        case .emptyResult:
            tableStateManager.setEmptyState()
        }
    }
}
