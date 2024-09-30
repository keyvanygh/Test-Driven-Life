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
    
    enum Error: Swift.Error {
        case clientNot200Reponse
        case invalidData
    }
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func create() async throws {
        let (data, response) = try await client.request(.POST, to: url)
        
        guard response.isOk_200 else {
            throw Error.clientNot200Reponse
        }
        
        throw Error.invalidData
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
    
    func test_create_throwOnNot200HttpResponse() async {
        let not200StatusCodes = [300, 401, 404, 500, 501, 503, 201, 202]
        
        for statusCode in not200StatusCodes {
            let (sut, client) = makeSUT()
            
            await expect(
                {
                    try await sut.create()
                },
                toThrow: RemoteTaskCreator.Error.clientNot200Reponse,
                when: {
                    client.returns(
                        with: (Data(),
                               HTTPURLResponse(statusCode: statusCode))
                    )
                }
            )
        }
    }
    
    func test_loadTwice_requestDataFromURLTwice() async {
        let url = URL.dummy
        let (sut, client) = makeSUT(url: url)
        
        Task {
            _ = try await sut.create()
        }
        
        Task {
            _ = try await sut.create()
        }

        await aFewMomentsLater()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_create_throwsInvalidDataErrorOnInvalidClientDataResponse() async {
        let url = URL.dummy
        let (sut, client) = makeSUT(url: url)
        let invalidData = ["invalidData": "invalidData"].data
        
        await expect(
            {
                try await sut.create()
            },
            toThrow: RemoteTaskCreator.Error.invalidData,
            when: {
                client.returns(with: (invalidData, .ok_200))
            }
        )
    }
    
    private func makeSUT(url: URL = .dummy) -> (RemoteTaskCreator, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTaskCreator(client: client, url: url)
        return (sut, client)
    }
    
    private func expect<Error: Equatable>(
        _ action: @escaping () async throws -> (),
        toThrow expectedError: Error,
        when: @escaping () -> (),
        file: StaticString = #file,
        line: UInt = #line
    ) async {
        
        let task = Task {
            do {
                _ = try await action()
                XCTFail("expected to throw but didn't")
            } catch {
                let receivedError = error as? Error
                XCTAssertEqual(receivedError, expectedError)
            }
        }
        
        await aFewMomentsLater()
        
        let when = Task {
            when()
        }
        
        _ = await (task.value, when.value)
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
