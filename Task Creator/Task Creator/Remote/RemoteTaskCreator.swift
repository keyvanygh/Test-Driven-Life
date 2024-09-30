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
    
    public func create() async throws -> TaskEntity {
        let (data, response) = try await client.request(.POST, to: url)
        
        guard response.isOk_200 else {
            throw Error.clientNot200Reponse
        }
        
        guard let task = try? RemoteTaskMapper.map(data: data) else {
            throw Error.invalidData
        }
        
        return task
    }
}
