//
//  TaskCreator.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation

public protocol TaskCreator {
    func create() async throws -> TaskEntity
}
