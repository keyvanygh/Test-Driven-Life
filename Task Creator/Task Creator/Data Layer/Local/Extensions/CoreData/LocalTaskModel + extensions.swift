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
        return "testABD"
    }
    
    public static func map(storeObject: NSManagedObject) throws -> LocalTaskModel {
        LocalTaskModel(title: "HI")
    }
    
    public func storeObject(for store: any DataStore) async throws -> NSManagedObject {
        throw NSError()
    }
    
}
