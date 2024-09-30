//
//  HTTPClientSpy.swift
//  Task CreatorTests
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation
import HttpClient

class HTTPClientSpy: HTTPClient {
    
    typealias Result = HTTPClient.Result
    typealias HttpMethod = HttpClient.HttpMethod
    typealias Log = (result: CheckedContinuation<Result, Error>, url: URL)
    
    public var requestedURLs: [URL] {
        return logs.map({ $0.url })
    }
    
    private var logs = [Log]()
    
    func request(
        _ httpMethod: HttpMethod,
        to url: URL,
        header: [String : String]? = nil,
        body: Data? = nil
    ) async throws -> Result {
        return try await withCheckedThrowingContinuation { continuation in
            logs.append((continuation,url))
        }
    }
    
    func returns(
        with result: Result = (Data(), .ok_200),
        index: Int = 0
    ) {
        logs[index].result.resume(returning: result)
    }
    
    func `throws`(
        with error: NSError = .dummy,
        index: Int = 0
    ) {
        logs[index].result.resume(throwing: error)
    }
}
