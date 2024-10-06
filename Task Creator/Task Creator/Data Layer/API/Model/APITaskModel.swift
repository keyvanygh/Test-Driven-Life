//
//  RemoteTask.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation

public struct APITaskModel: Codable {
    let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    var entity: TaskEntity {
        return TaskEntity(title: title)
    }
}
