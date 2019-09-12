//
//  Created by Filipp Lebedev on 05/05/2019.
//

import RealmSwift

class MapDataStore: AbstractDataStore {
    
    func setupCityObserving(completion: @escaping ([CityStorageModel]?, Error?) -> Void) {
        storageManager.setupObjectsObserver(type: CityStorageModel.self) { (items, error) in
            completion(items, error)
        }
    }
}
