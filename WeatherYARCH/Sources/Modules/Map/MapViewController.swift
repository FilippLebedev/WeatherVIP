//
//  Map module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit
import MapKit

protocol MapDisplayLogic: class {
    func displayCities(viewModel: Map.ShowCities.ViewModel)
    func displayWeather(viewModel: Map.GetWeather.ViewModel)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MapView!
    
    @IBAction func citiesButtonPressed(_ sender: Any) {
        pushCities()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        pushSearch()
    }
    
    @IBAction func plusZoomPressed(_ sender: Any) {
        zoomIn()
    }
    
    @IBAction func minusZoomPressed(_ sender: Any) {
        zoomOut()
    }
    
    var interactor: MapBusinessLogic?
    var state: Map.ViewControllerState = .loading

    let emptyStateView = EmptyStateView()
    lazy var warningBanner = WarningBanner(for: view)
    
    func setup(interactor: MapBusinessLogic, initialState: Map.ViewControllerState = .loading) {
        self.interactor = interactor
        self.state = initialState
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupEmptyStateView()
        setupWarningBannerView()
        
        interactor?.setupCitiesObserving(request: Map.ShowCities.Request())
    }
    
    private func setupNavigationBar() {
        let colors: [UIColor] = [UIColor(hex: "0093E9"), UIColor(hex: "80D0C7")]
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    private func setupEmptyStateView() {
        emptyStateView.isHidden = true
        emptyStateView.text = "Tap [+] to add the city"
        
        view.addSubview(emptyStateView)
        
        emptyStateView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupWarningBannerView() {
        if AppPrivateData.openWeatherMapAPIKey == "" {
            let text = "You did not set API key for OpenWeatherMap. Create account on openweathermap.org to get private key and then specify it into AppPrivateData.swift"
            warningBanner.present(text)
        }
    }
    
    private func updateView(_ models: [MapCityModel]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for (index, city) in models.enumerated() {
            let ann = MapCityAnnotation(cityId: city.id, name: city.name, coordinate: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude))
            mapView.addAnnotation(ann)
            
            // Request actual temperature
            
            interactor?.getWeatherForCity(request: Map.GetWeather.Request(cityId: city.id))
            
            if index == models.count - 1 {
                mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)), animated: true)
            }
        }
    }
    
    private func zoomIn() {
        mapView.zoomIn()
    }
    
    private func zoomOut() {
        mapView.zoomOut()
    }
    
    private func pushCities() {
        let citiesController = CitiesBuilder().set(initialState: .loading).build()
        navigationController?.pushViewController(citiesController, animated: true)
    }
    
    private func pushSearch() {
        let searchController = SearchBuilder().set(initialState: .loading).build()
        navigationController?.pushViewController(searchController, animated: true)
    }
}

extension MapViewController: MapDisplayLogic {
    func displayCities(viewModel: Map.ShowCities.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func displayWeather(viewModel: Map.GetWeather.ViewModel) {
        if let annotation = mapView.annotations.filter({ ($0 as! MapCityAnnotation).cityId == viewModel.model.cityId }).first as? MapCityAnnotation {
            DispatchQueue.main.async { [weak self] in
                annotation.temp = viewModel.model.temp
                self?.mapView.view(for: annotation)?.layoutSubviews()
            }
        }
    }

    func display(newState: Map.ViewControllerState) {
        state = newState
        
        switch state {
        case .loading:
            emptyStateView.isHidden = true
            break
        case let .error(message):
            emptyStateView.isHidden = true
            print("Error when updating the cities on map: \(message)")
        case let .result(items):
            emptyStateView.isHidden = true
            updateView(items)
        case .emptyResult:
            updateView([])
            emptyStateView.isHidden = false
            break
        }
    }
}
