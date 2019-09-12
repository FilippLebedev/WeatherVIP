//
//  City module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit

class CityBuilder: ModuleBuilder {

    var initialState: City.ViewControllerState?

    func set(initialState: City.ViewControllerState) -> CityBuilder {
        self.initialState = initialState
        return self
    } 

    func build() -> UIViewController {
        guard let initialState = initialState else {
            fatalError("Initial state parameter for City was not set")
        }
        
        let presenter = CityPresenter()
        let interactor = CityInteractor(presenter: presenter)
        
        let storyboard = UIStoryboard(name: "CityStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CityViewController") as? CityViewController
        controller?.setup(interactor: interactor, initialState: initialState)

        presenter.viewController = controller
        
        return controller ?? UIViewController()
    }
}
