//
//  RemoteTaskCreatorTests.swift
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation
import XCTest
import HttpClient
import Task_Creator

public protocol TaskCreator {
    func create() async throws
}

public final class RemoteTaskCreator {

    let client: HTTPClient
    let url: URL
    
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
}

final class RemoteTaskCreatorTests: XCTestCase {
    
    func test_init_doseNotCreateTask() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    private func makeSUT(url: URL = .dummy) -> (RemoteTaskCreator, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTaskCreator(client: client, url: url)
        return (sut, client)
    }
}
