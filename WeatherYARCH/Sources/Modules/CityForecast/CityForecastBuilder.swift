//
//  CityForecast module
//  Created by Filipp Levedev on 29/05/2019.
//

import UIKit

class CityForecastBuilder: ModuleBuilder {

    var initialState: CityForecast.ViewControllerState?

    func set(initialState: CityForecast.ViewControllerState) -> CityForecastBuilder {
        self.initialState = initialState
        return self
    } 

    func build() -> UIViewController {
        guard let initialState = initialState else {
            fatalError("Initial state parameter for Forecast was not set")
        }
        
        let presenter = CityForecastPresenter()
        let interactor = CityForecastInteractor(presenter: presenter)
        
        let storyboard = UIStoryboard(name: "CityForecastStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CityForecastViewController") as? CityForecastViewController
        controller?.setup(interactor: interactor, initialState: initialState)

        presenter.viewController = controller
        return controller ?? UIViewController()
    }
}
