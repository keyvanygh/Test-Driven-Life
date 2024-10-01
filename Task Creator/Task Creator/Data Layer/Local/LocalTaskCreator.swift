//
//  LocalTaskCreator.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation
import DataStore
import CoreData

public protocol TaskDataStore: DataStore where Item == LocalTaskModel {}

public class LocalTaskCreator: TaskCreator {
    
    private let store: any TaskDataStore
    
    public init(store: any TaskDataStore) {
        self.store = store
    }
    
    public func create(with parameters: any TaskCreationParameters) async throws -> TaskEntity {
        let item = LocalTaskModel(title: parameters.title)
        
        try await store.save(item)
        let savedItem = try await store.load()
        return TaskEntity(title: savedItem.title)
    }
}
