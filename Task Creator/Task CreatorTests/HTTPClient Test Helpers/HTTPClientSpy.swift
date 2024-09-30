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
    typealias Log = (result: CheckedContinuation<Result, Error>, request: URLRequest)
    
    public var requestedURLs: [URL] {
        return logs.compactMap({ $0.request.url })
    }

    public var requests: [URLRequest] {
        return logs.map { $0.request }
    }
    
    private var logs = [Log]()
    
    func request(
        _ httpMethod: HttpMethod,
        to url: URL,
        header: [String : String]? = nil,
        body: Data? = nil
    ) async throws -> Result {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = body
        if let header {
            urlRequest.allHTTPHeaderFields = urlRequest.allHTTPHeaderFields?.merging(header, uniquingKeysWith: { (_, new) in new })
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            logs.append((continuation, urlRequest))
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
