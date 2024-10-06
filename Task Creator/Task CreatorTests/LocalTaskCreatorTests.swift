//
//  LocalTaskCreatorTests.swift
//  Task CreatorTests
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import XCTest
import Task_Creator
import DataStore
import ConcurrencyExtras

final class LocalTaskCreatorTests: XCTestCase {
    
    func test_init_doseNotRequestStoreToCreateTask() {
        let store = TaskDataStoreSpy()
        let _ = LocalTaskCreator(store: store)
        
        XCTAssertEqual(store.events, [])
    }
    
    func test_create_throwsOnStoreError() async throws {
        let store = TaskDataStoreSpy()
        let sut = LocalTaskCreator(store: store)
        
        Task {
            try await sut.create(with: .any)
        }
        
        await aFewMomentsLater()
        
        store.returns(with: LocalTaskModel(title: ""))
        
        await aFewMomentsLater()
        
        XCTAssertEqual(store.events, [.save])
    }

    func test_create_returnsTaskStoreSaveSuccess() async throws {
        let store = TaskDataStoreSpy()
        let parameters = TaskCreationParameters(title: "a test task")
        let sut = LocalTaskCreator(store: store)
        
        let task = Task {
            try await sut.create(with: parameters)
        }
        
        await aFewMomentsLater()
        
        store.returns(with: LocalTaskModel(title: parameters.title))
        
        await aFewMomentsLater()
        
        let savedTask = try await task.value
        
        XCTAssertEqual(savedTask, TaskEntity(title: parameters.title))
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



public class TaskDataStoreSpy: TaskDataStore {
    typealias Log = (result: CheckedContinuation<Item, Error>, event: Event)

    enum Event {
        case load
        case save
        case clear
    }

    private var logs = [Log]()

    var events: [Event] {
        return logs.map { $0.event }
    }
    
    public func load() async throws -> Item {
        return try await withCheckedThrowingContinuation { continuation in
            logs.append((continuation, .load))
        }
    }
    
    public func save(_ item: Item) async throws -> Item {
       return try await withCheckedThrowingContinuation { continuation in
            logs.append((continuation, .save))
        }
    }
    
    public func clear() async throws {
        _ = try await withCheckedThrowingContinuation { continuation in
            logs.append((continuation, .clear))
        }
    }
    
    func returns(
        with result: Item,
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

extension NSPersistentContainer {
    static func testContainer(
        with model: NSManagedObjectModel = TestManageObject1.make()
    ) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "TestContainer", managedObjectModel: model)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _,_  in }
        
        return container
    }
}

@objc(TestManageObject1)
final class TestManageObject1: NSManagedObject {
    @NSManaged var stringTestAttribute: String
}

extension TestManageObject1 {
    static func make() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        let entity = NSEntityDescription()
        entity.name = "TestManageObject1"
        entity.managedObjectClassName = NSStringFromClass(TestManageObject1.self)
        
        let attribute = NSAttributeDescription()
        attribute.name = "stringTestAttribute"
        attribute.attributeType = .stringAttributeType
        attribute.isOptional = false
        entity.properties = [attribute]
        
        model.entities = [entity]
        
        return model
    }
}
