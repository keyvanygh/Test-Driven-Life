//
//  TaskCreator.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation

public protocol TaskCreator {
    associatedtype Parameters: TaskCreationParameters
    func create(with parameters: Parameters) async throws -> TaskEntity
}

public protocol TaskCreationParameters {
    var title: String { get }
}
