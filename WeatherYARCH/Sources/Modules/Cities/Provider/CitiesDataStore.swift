//
//  Created by Filipp Lebedev on 05/05/2019.
//

import RealmSwift

class CitiesDataStore: AbstractDataStore {
    
    func setupCityObserving(completion: @escaping ([CityStorageModel]?, Error?) -> Void) {
        storageManager.setupObjectsObserver(type: CityStorageModel.self) { [weak self] (items, error) in
            if let items = items {
                completion(items, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func deleteCity(id: UniqueIdentifier, completion: @escaping (_ success: Bool) -> Void) {
        storageManager.delete(type: CityStorageModel.self, id: id) { [weak self] (success) in
            completion(success)
        }
    }
}
