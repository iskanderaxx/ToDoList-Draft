//
//  MainInteractor.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set } // Shall have reference to Presenter
    
    func fetchTasks()
}

final class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    var coreDataManager = CoreDataManager.shared
    
    func fetchTasks() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetchTasks(with: .failure(FetchError.failed))
                return
            }
            
            do {
//              let tasks = try JSONDecoder().decode([ToDoList].self, from: data)
                let toDoItems = try JSONDecoder().decode([TaskItem].self, from: data)
                let tasks = toDoItems.map { toDoItem -> TaskList in
                    let task = TaskList(context: CoreDataManager.shared.context) // coreDataManager
                    task.title = toDoItem.title
                    task.isCompleted = toDoItem.completed
                    return task
                }
                CoreDataManager.shared.saveContext()
                self?.presenter?.interactorDidFetchTasks(with: .success(tasks))
            } catch {
                self?.presenter?.interactorDidFetchTasks(with: .failure(error))
            }
        }
        task.resume()
    }
}
