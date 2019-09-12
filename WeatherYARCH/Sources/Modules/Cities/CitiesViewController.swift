//
//  Cities module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit
import Alertift

protocol CitiesDisplayLogic: class {
    func displayCities(viewModel: Cities.ShowCities.ViewModel)
    func displayCityDeletion(viewModel: Cities.DeleteCity.ViewModel)
}

protocol CitiesViewControllerDelegate: AnyObject {
    func selectCity(id: UniqueIdentifier)
    func deleteCity(id: UniqueIdentifier)
}

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: CitiesBusinessLogic?
    var state: Cities.ViewControllerState = .loading
    
    var tableDataSource: CitiesTableDataSource = CitiesTableDataSource()
    var tableHandler: CitiesTableDelegate = CitiesTableDelegate()
    var tableStateManager: TableStateManager = CitiesTableStateManager()

    func setup(interactor: CitiesBusinessLogic, initialState: Cities.ViewControllerState = .loading) {
        self.interactor = interactor
        self.state = initialState
        
        tableHandler.delegate = self
        tableDataSource.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = tableHandler
        tableView.dataSource = tableDataSource
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableStateManager.tableView = tableView
        
        interactor?.setupCitiesObserving(request: Cities.ShowCities.Request())
    }
    
    private func updateView(_ models: [CitiesCityModel]) {
        tableDataSource.representableViewModels = models
        tableHandler.representableViewModels = models
        tableView.reloadData()
    }
    
    private func pushCity(id: UniqueIdentifier) {
        let cityController = CityBuilder().set(initialState: .initial(id: id)).build()
        navigationController?.pushViewController(cityController, animated: true)
    }
}

extension CitiesViewController: CitiesDisplayLogic {
    
    func displayCities(viewModel: Cities.ShowCities.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func displayCityDeletion(viewModel: Cities.DeleteCity.ViewModel) {
        if viewModel.isSuccess {
            // View will update automatically by notification
        } else if let message = viewModel.errorMessage {
            Alertift.alert(title: "Error", message: message)
                .action(.default("OK"))
                .show()
        }
    }

    private func display(newState: Cities.ViewControllerState) {
        state = newState
        switch state {
        case .loading:
            tableStateManager.setResultState()
        case let .error(message):
            Alertift.alert(title: "Error", message: message)
                .action(.default("OK"))
                .show()
            tableStateManager.setResultState()
        case let .result(items):
            updateView(items)
            tableStateManager.setResultState()
        case .emptyResult:
            updateView([])
            tableStateManager.setEmptyState()
        }
    }
}

extension CitiesViewController: CitiesViewControllerDelegate {
    
    func selectCity(id: UniqueIdentifier) {
        pushCity(id: id)
    }
    
    func deleteCity(id: UniqueIdentifier) {
        interactor?.deleteCity(request: Cities.DeleteCity.Request(cityId: id))
    }
}
