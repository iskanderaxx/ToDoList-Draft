//
//  MainInteractor.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit

protocol MainInteractorProtocol {
    var presenter: MainPresenterProtocol? { get set }
    func fetchTasks()
}

final class MainInteractor: MainInteractorProtocol {
    var presenter: MainPresenterProtocol? // Shall have reference to Presenter
//    var coreDataManager = CoreDataManager.shared
    
    func fetchTasks() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
//                self?.presenter?.failedToFetchTasks(with: error)
//                self?.presenter?.interactorDidFetchTasks(with: .failure(error))
                self?.presenter?.interactorDidFailFetchTasks(with: error)
                return
            }
            
            guard let data = data else { return }
//                self?.presenter?.interactorDidFetchTasks(with: .failure(FetchError.failed))
            do {
//              let tasks = try JSONDecoder().decode([ToDoList].self, from: data)
                let response = try JSONDecoder().decode([TaskList].self, from: data)
//                self?.presenter?.fetchTasks(with: response)
                self?.presenter?.interactorDidFetchTasks(response)
//                  X self?.presenter?.didFetchTasks(with: response)
//                let tasks = toDoItems.map { toDoItem -> TaskList in
//                    let task = TaskList(context: CoreDataManager.shared.context) // coreDataManager
//                    task.title = toDoItem.title
//                    task.isCompleted = toDoItem.completed
//                    return task
//                }
//                CoreDataManager.shared.saveContext()
//                self?.presenter?.interactorDidFetchTasks(with: .success(tasks))
            } catch {
//                self?.presenter?.interactorDidFetchTasks(with: .failure(error))
                self?.presenter?.interactorDidFailFetchTasks(with: error)
            }
        }
        task.resume()
    }
}
