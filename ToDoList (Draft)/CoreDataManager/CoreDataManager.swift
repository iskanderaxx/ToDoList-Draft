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
        let container = NSPersistentContainer(name: "ToDoList")
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
    
    func fetchAllTasks() -> [ToDoList] {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print("Tasks fetching went wrong with error: \(error), please try again.")
            return []
        }
    }
    
    func createTask(title: String) {
        let task = ToDoList(context: context)
        task.title = title
        
        do {
            try context.save()
        } catch {
            print("Task creation went wrong with error: \(error), please try again.")
            interactor?.presenter?.view?.showError(error)
        }
    }
    
    func updateTask(_ task: ToDoList, newTitle: String, isCompleted: Bool, userID: Int) {
        task.title = newTitle
        task.completed = isCompleted
        task.userID = userID
        
        do {
            try context.save()
        } catch {
            interactor?.presenter?.view?.showError(error)
        }
    }
    
    func deleteTask(_ task: ToDoList) {
        context.delete(task)
        
        do {
            try context.save()
        } catch {
            interactor?.presenter?.view?.showError(error)
        }
    }
}
