//
//  RemoteTask.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation

struct RemoteTask: Codable {
    let title: String
    
    var entity: TaskEntity {
        return TaskEntity(title: title)
    }
}
