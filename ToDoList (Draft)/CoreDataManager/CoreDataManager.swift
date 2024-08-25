//
//  CoreDataManager.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private var interactor: MainInteractor?
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList__Draft_")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: CRUD stack
    
//    func fetchAllTasks() -> [TaskList] {
//        do {
//            let tasks = try context.fetch(TaskList.fetchRequest())
//            return tasks
//        } catch {
//            print("Tasks fetching went wrong with error: \(error), please try again.")
//            return []
//        }
//    }
//    
//    func createTask(title: String) {
//        let task = TaskList(context: context)
//        task.title = title
//        
//        do {
//            try context.save()
//        } catch {
//            interactor?.presenter?.view?.update(with: error)
//        }
//    }
//    
//    func updateTask(_ task: TaskList, newTitle: String, newContents: String, isCompleted: Bool, newDate: Date) {
//        task.title = newTitle
//        task.contents = newContents
//        task.isCompleted = isCompleted
//        task.date = newDate
//        
//        do {
//            try context.save()
//        } catch {
//            interactor?.presenter?.view?.update(with: error)
//        }
//    }
//    
//    func deleteTask(_ task: TaskList) {
//        context.delete(task)
//        
//        do {
//            try context.save()
//        } catch {
//            interactor?.presenter?.view?.update(with: error)
//        }
//    }
}
