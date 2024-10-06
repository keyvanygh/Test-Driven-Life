//
//  LocalTaskModel + extensions.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 10/1/24.
//

import DataStore
import CoreData

extension LocalTaskModel: CoreDataStoreable {
    public static func entityName() throws -> String {
        return "CoreDataTaskObject"
    }
    
    public static func map(storeObject: NSManagedObject) throws -> LocalTaskModel {
        guard let storeObject = storeObject as? CoreDataTaskObject else {
            throw CoreDataStore<LocalTaskModel>.StoreError.itemNotFound
        }
        return LocalTaskModel(title: storeObject.title)
    }
    
    public func storeObject(for store: any DataStore) async throws -> NSManagedObject {
        guard let coreDataStore = store as? CoreDataStore<LocalTaskModel> else {
            throw CoreDataStore<LocalTaskModel>.StoreError.itemNotFound
        }
        guard let item = try await coreDataStore.item() as? CoreDataTaskObject else {
            throw CoreDataStore<LocalTaskModel>.StoreError.itemNotFound
        }
        item.title = title
        return item
    }
    
}
