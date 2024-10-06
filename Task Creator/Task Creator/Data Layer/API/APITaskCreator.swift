//
//  RemoteTaskCreator.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import HttpClient

public final class APITaskCreator: TaskCreator {
    
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
        let parametesrsData = try JSONEncoder().encode(APITaskModel(title: parametesrs.title))

        let (data, response) = try await client.request(.POST, to: url, body: parametesrsData)
        
        guard response.isOk_200 else {
            throw Error.clientNot200Reponse
        }
        
        guard let task = try? APITaskMapper.map(data: data) else {
            throw Error.invalidData
        }
        
        return task
    }
}
