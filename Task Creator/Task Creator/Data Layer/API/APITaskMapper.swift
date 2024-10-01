//
//  RemoteTaskMapper.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation

struct APITaskMapper {
    static func map(data: Data) throws -> TaskEntity {
        return try JSONDecoder().decode(APITaskModel.self, from: data).entity
    }
}
