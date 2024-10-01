//
//  CoreDataTaskObject.swift
//  Task Creator
//
//  Created by Keyvan Yaghoubian on 10/1/24.
//

import CoreData
import DataStore

@objc(CoreDataTaskObject)
public class CoreDataTaskObject: NSManagedObject {
    @NSManaged public var title: String
}
