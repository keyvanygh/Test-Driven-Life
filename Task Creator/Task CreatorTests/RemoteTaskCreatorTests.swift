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

final class RemoteTaskCreatorTests: XCTestCase {
    
    func test_init_doseNotCreateTask() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_create_clientSendsExpectedURLRequest() async {
        let aURL: URL = .dummy
        let (sut, client) = makeSUT(url: aURL)
        let parameters = RemoteTaskCreationParameters(title: "a test task")
        
        let expectedURLRequest = URLRequest(url: aURL, with: parameters)

        Task {
            _ = try await sut.create(with: parameters)
        }
        
        await aFewMomentsLater()
        
        XCTAssertEqual(client.requests, [expectedURLRequest])
        XCTAssertEqual(client.requests.first!.httpBody, expectedURLRequest.httpBody)
    }
    
    func test_create_throwOnNot200HttpResponse() async {
        let not200StatusCodes = [300, 401, 404, 500, 501, 503, 201, 202]
        
        for statusCode in not200StatusCodes {
            let (sut, client) = makeSUT()
            
            await expect(
                {
                    _ = try await sut.create(with: RemoteTaskCreationParameters.any)
                },
                toThrow: APITaskCreator.Error.clientNot200Reponse,
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
            _ = try await sut.create(with: RemoteTaskCreationParameters.any)
        }
        
        Task {
            _ = try await sut.create(with: RemoteTaskCreationParameters.any)
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
                _ = try await sut.create(with: RemoteTaskCreationParameters.any)
            },
            toThrow: APITaskCreator.Error.invalidData,
            when: {
                client.returns(with: (invalidData, .ok_200))
            }
        )
    }
    
    func test_create_returnsTaskEntityOnClientSuccessWithCorrectData() async {
        let url = URL.dummy
        let (sut, client) = makeSUT(url: url)
        let validData = ["title": "a task title"].data
        let expectedTask = TaskEntity(title: "a task title")
        
        await expect(
            {
                try await sut.create(with: RemoteTaskCreationParameters.any)
            },
            toReturn: expectedTask,
            when: {
                client.returns(with: (validData, .ok_200))
            }
        )
    }
    
    private func makeSUT(url: URL = .dummy) -> (APITaskCreator, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = APITaskCreator(client: client, url: url)
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
    
    private func expect<ReturnType: Equatable>(
        _ action: @escaping () async throws -> ReturnType,
        toReturn: ReturnType,
        when: @escaping () -> (),
        file: StaticString = #file,
        line: UInt = #line
    ) async {
        
        let task = Task {
            do {
                let result = try await action()
                XCTAssertEqual(result, toReturn, file: file, line: line)
            } catch {
                XCTFail("expected to return \(toReturn), but throws \(error)", file: file, line: line)
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
