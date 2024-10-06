//
//  TaskCreator.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation

public protocol TaskCreator {
    func create(with parameters: TaskCreationParameters) async throws -> TaskEntity
}

public class TaskCreationParameters {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}
