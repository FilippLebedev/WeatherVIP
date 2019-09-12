//
//  Map module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit

class MapBuilder: ModuleBuilder {

    var initialState: Map.ViewControllerState?

    func set(initialState: Map.ViewControllerState) -> MapBuilder {
        self.initialState = initialState
        return self
    } 

    func build() -> UIViewController {
        let presenter = MapPresenter()
        let interactor = MapInteractor(presenter: presenter)
        
        let storyboard = UIStoryboard(name: "MapStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        controller?.setup(interactor: interactor)
        
        presenter.viewController = controller
        
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        navigationController.viewControllers = [controller] as! [UIViewController]
        
        return navigationController
    }
}
