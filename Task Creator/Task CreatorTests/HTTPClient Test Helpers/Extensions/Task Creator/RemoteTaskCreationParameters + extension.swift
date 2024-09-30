//
//  RemoteTaskCreationParameters + extension.swift
//  Task CreatorTests
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Task_Creator

extension RemoteTaskCreationParameters {
    static var dummy: TaskCreationParameters { RemoteTaskCreationParameters(title: "a dummy task") }
    static var any: TaskCreationParameters { RemoteTaskCreationParameters(title: "any task") }
}
