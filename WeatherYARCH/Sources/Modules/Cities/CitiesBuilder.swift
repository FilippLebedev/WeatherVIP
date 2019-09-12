//
//  Cities module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit

class CitiesBuilder: ModuleBuilder {

    var initialState: Cities.ViewControllerState?

    func set(initialState: Cities.ViewControllerState) -> CitiesBuilder {
        self.initialState = initialState
        return self
    } 

    func build() -> UIViewController {
        let presenter = CitiesPresenter()
        let interactor = CitiesInteractor(presenter: presenter)
        
        let storyboard = UIStoryboard(name: "CitiesStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CitiesViewController") as? CitiesViewController
        controller?.setup(interactor: interactor)

        presenter.viewController = controller
        
        return controller ?? UIViewController()
    }
}
