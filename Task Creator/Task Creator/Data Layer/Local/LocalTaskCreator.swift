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
    
    public func create(with parameters: LocalTaskCreationParameters) async throws -> TaskEntity {
        let item = LocalTaskModel(title: parameters.title)
        
        return try await store.save(item).entity
    }
}

public struct LocalTaskCreationParameters: TaskCreationParameters {
    public var title: String
    
    public init(title: String) {
        self.title = title
    }
}

