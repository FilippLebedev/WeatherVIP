//
//  Created by Filipp Lebedev on 05/05/2019.
//

import RealmSwift

class SearchDataStore: AbstractDataStore {
    
    func cityById(_ id: UniqueIdentifier, completion: @escaping (CityStorageModel?) -> Void) {
        storageManager.object(type: CityStorageModel.self, id: id) { [weak self] (item) in
            completion(item)
        }
    }
    
    func addCity(_ model: CityStorageModel, completion: @escaping (_ success: Bool) -> Void) {
        storageManager.create(model) { [weak self] (success) in
            completion(success)
        }
    }
}
