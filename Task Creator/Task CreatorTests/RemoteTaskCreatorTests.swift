//
//  RemoteTaskCreatorTests.swift
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation
import XCTest
import HttpClient
import Task_Creator
import ConcurrencyExtras

public protocol TaskCreator {
    func create() async throws
}

public final class RemoteTaskCreator: TaskCreator {

    let client: HTTPClient
    let url: URL
    
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func create() async throws {
        _ = try await client.request(.POST, to: url)
    }
    
}

final class RemoteTaskCreatorTests: XCTestCase {
    
    func test_init_doseNotCreateTask() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_create_clientSendsExpectedURLRequest() async {
        let aURL: URL = .dummy
        let (sut, client) = makeSUT(url: aURL)
        
        var expectedURLRequest = URLRequest(url: aURL)
        expectedURLRequest.httpMethod = HttpMethod.POST.rawValue
        expectedURLRequest.allHTTPHeaderFields = [:]
        expectedURLRequest.httpBody = nil
        
        Task {
            try await sut.create()
        }
        
        await aFewMomentsLater()
        
        XCTAssertEqual(client.requests, [expectedURLRequest])
    }
    
    private func makeSUT(url: URL = .dummy) -> (RemoteTaskCreator, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTaskCreator(client: client, url: url)
        return (sut, client)
    }
    
    private func aFewMomentsLater() async {
        await Task.yield()
    }
    
    override func invokeTest() {
        withMainSerialExecutor {
            super.invokeTest()
        }
    }
}
