//
//  Search module
//  Created by Filipp Lebedev on 05/05/2019.
//

import UIKit

class SearchBuilder: ModuleBuilder {

    var initialState: Search.ViewControllerState?

    func set(initialState: Search.ViewControllerState) -> SearchBuilder {
        self.initialState = initialState
        return self
    } 

    func build() -> UIViewController {
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter)
        
        let storyboard = UIStoryboard(name: "SearchStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        controller?.setup(interactor: interactor)

        presenter.viewController = controller
        
        return controller ?? UIViewController()
    }
}
