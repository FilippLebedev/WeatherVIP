//
//  Search module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit
import Alertift

protocol SearchDisplayLogic: class {
    func displayCities(viewModel: Search.SearchCity.ViewModel)
    func displayCityExistance(viewModel: Search.CheckCityExistance.ViewModel)
    func displayCityAddResult(viewModel: Search.AddCity.ViewModel)
}

protocol SearchViewControllerDelegate: AnyObject {
    func searchCity(text: String)
    func selectCity(model: SearchCityModel)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var interactor: SearchBusinessLogic?
    var state: Search.ViewControllerState = .initial

    var searchBarHandler: SearchSearchBarDelegate = SearchSearchBarDelegate()
    var tableDataSource: SearchTableDataSource = SearchTableDataSource()
    var tableHandler: SearchTableDelegate = SearchTableDelegate()
    var tableStateManager: TableStateManager = SearchTableStateManager()
    
    func setup(interactor: SearchBusinessLogic, initialState: Search.ViewControllerState = .initial) {
        self.interactor = interactor
        self.state = initialState
        
        searchBarHandler.delegate = self
        tableHandler.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = searchBarHandler
        
        tableView.delegate = tableHandler
        tableView.dataSource = tableDataSource
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableStateManager.tableView = tableView
        
        display(newState: .initial)
    }
    
    private func updateView(_ models: [SearchCityModel]) {
        tableDataSource.representableViewModels = models
        tableHandler.representableViewModels = models
        tableView.reloadData()
    }
    
    private func addCity(request: Search.AddCity.Request) {
        interactor?.addCity(request: request)
    }
}

extension SearchViewController: SearchDisplayLogic {
    
    func displayCities(viewModel: Search.SearchCity.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func displayCityExistance(viewModel: Search.CheckCityExistance.ViewModel) {
        let model = viewModel.model
        let isExists = viewModel.isExists
        
        DispatchQueue.main.async { [weak self] in
            if isExists {
                Alertift.alert(title: "City can't be appended", message: "\(model.name) already exists (ID: \(model.id))")
                    .action(.default("OK"))
                    .show()
            } else {
                Alertift.alert(title: "City appending", message: "Would you like to add \(model.name)?")
                    .action(.default("Yes")) { _, _, _ in
                        self?.addCity(request: Search.AddCity.Request(model: model))
                    }
                    .action(.cancel("Cancel"))
                    .show()
            }
        }
    }
    
    func displayCityAddResult(viewModel: Search.AddCity.ViewModel) {
        let isSuccess = viewModel.isSuccess
        
        DispatchQueue.main.async { [weak self] in
            if isSuccess {
                Alertift.alert(title: "Done", message: "City added to storage")
                    .action(.default("OK")) { [weak self] _, _, _ in
                        self?.navigationController?.popViewController(animated: true)
                        self?.dismiss(animated: true, completion: nil)
                    }
                    .show()
            } else {
                Alertift.alert(title: "Failed", message: "City can't be added")
                    .action(.default("OK"))
                    .show()
            }
        }
    }

    func display(newState: Search.ViewControllerState) {
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
        case .initial:
            tableStateManager.setInitialState()
        }
    }
}

extension SearchViewController: SearchViewControllerDelegate {
    
    func selectCity(model: SearchCityModel) {
        interactor?.checkCityExists(request: Search.CheckCityExistance.Request(model: model))
    }
    
    func searchCity(text: String) {
        let request = Search.SearchCity.Request(searchText: text)
        interactor?.searchCity(request: request)
    }
}
