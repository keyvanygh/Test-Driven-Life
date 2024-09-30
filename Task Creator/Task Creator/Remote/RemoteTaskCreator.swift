//
//  RemoteTaskCreator.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import HttpClient

public final class RemoteTaskCreator: TaskCreator {
    
    let client: HTTPClient
    let url: URL
    
    public enum Error: Swift.Error {
        case clientNot200Reponse
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func create(with parametesrs: TaskCreationParameters) async throws -> TaskEntity {
        guard let parametesrs = parametesrs as? RemoteTaskCreationParameters else {
            throw Error.invalidData
        }
        
        let parametesrsData = try JSONEncoder().encode(parametesrs)

        let (data, response) = try await client.request(.POST, to: url, body: parametesrsData)
        
        guard response.isOk_200 else {
            throw Error.clientNot200Reponse
        }
        
        guard let task = try? RemoteTaskMapper.map(data: data) else {
            throw Error.invalidData
        }
        
        return task
    }
}

public struct RemoteTaskCreationParameters: TaskCreationParameters, Encodable {
    public var title: String
    
    public init(title: String) {
        self.title = title
    }
}

