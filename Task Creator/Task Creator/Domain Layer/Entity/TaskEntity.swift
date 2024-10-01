//
//  TaskEntity.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation

public struct TaskEntity: Equatable {
    let title: String
    
    public init(title: String) {
        self.title = title
    }
}
