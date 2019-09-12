//
//  City module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit
import Alertift
import SnapKit

protocol CityDisplayLogic: class {
    func displayWeather(viewModel: City.ShowWeather.ViewModel)
}

class CityViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: TemperatureLabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var interactor: CityBusinessLogic?
    var state: City.ViewControllerState = .loading

    func setup(interactor: CityBusinessLogic, initialState: City.ViewControllerState = .loading) {
        self.interactor = interactor
        self.state = initialState
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch state {
        case let .initial(id):
            interactor?.fetchWeather(request: City.ShowWeather.Request(cityId: id))
            presentForecast(cityId: id)
        default:
            break
        }
    }
    
    private func updateWeather(_ model: CityWeatherModel) {
        tempLabel.value = model.temp
        cityNameLabel.text = model.name
        cityNameLabel.isHidden = false
    }
    
    private func presentForecast(cityId: UniqueIdentifier) {
        let forecastController = CityForecastBuilder().set(initialState: .initial(cityId: cityId)).build()
        addChild(forecastController)
        containerView.addSubview(forecastController.view)
        
        forecastController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension CityViewController: CityDisplayLogic {
    
    func displayWeather(viewModel: City.ShowWeather.ViewModel) {
        display(newState: viewModel.state)
    }

    func display(newState: City.ViewControllerState) {
        state = newState
        switch state {
        case .loading:
            break
        case let .error(message):
            Alertift.alert(title: "Error", message: message)
                .action(.default("OK"))
                .show()
        case let .result(items):
            updateWeather(items)
        case .emptyResult:
            break
        default:
            break
        }
    }
}
