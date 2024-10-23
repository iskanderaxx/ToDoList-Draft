//
//  CoreDataManager.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
   lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Failed to save tasks: \(error), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: CRUD stack
    
    func getAllTasks() -> [ToDoList] {
        do {
            let tasks = try context.fetch(ToDoList.fetchRequest())
            return tasks
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func createTask(title: String) {
        let newTask = ToDoList(context: context)
        newTask.title = title
        
        saveContext()
    }
    
    func updateTask(_ task: ToDoList, newTitle: String) {
        task.title = newTitle
    
        saveContext()
    }
    
    func deleteTask(_ task: ToDoList) {
        context.delete(task)
        
        saveContext()
    }
}
