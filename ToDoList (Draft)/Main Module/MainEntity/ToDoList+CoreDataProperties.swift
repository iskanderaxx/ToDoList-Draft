//
//  ToDoList+CoreDataProperties.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import CoreData

@objc(ToDoList)
public class ToDoList: NSManagedObject {
    
}

extension ToDoList {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }
    
    @NSManaged public var id: Int
    @NSManaged public var title: String?
    @NSManaged public var completed: Bool
    @NSManaged public var userID: Int
}

extension ToDoList: Identifiable {
    static var managedPropertiesCount: Int {
        return 4
    }
}

