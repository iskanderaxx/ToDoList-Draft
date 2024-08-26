//
//  MainPresenter.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit

protocol MainPresenterProtocol {
    // Shall have references to View, Interactor & Router
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorProtocol? { get set }
    var router: MainRouter? { get set }
    var tasksCount: Int { get }
    
    func viewDidLoad()
    func interactorDidFetchTasks(_ result: [TaskList])
    func interactorDidFailFetchTasks(with error: Error)
    func receiveTask(at index: Int) -> TaskList?
//    func getAllTasks()
    func addNewTask(_ title: String)
    func updateTheTask(_ task: ToDoList, title: String, isCompleted: Bool, userID: Int)
    func deleteTask(_ task: ToDoList)
}

// Доработать enum
enum FetchError: Error {
    case failed
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouter?
    private var tasks: [TaskList] = []
    private var storedTasks: [ToDoList] = [] // Это надо убрать
    private var coreDataManager = CoreDataManager.shared
    
    var tasksCount: Int { tasks.count }
    
    // MARK: - Setup
    
    func viewDidLoad() {
        interactor?.fetchTasks()
        storedTasks = coreDataManager.fetchAllTasks()
        view?.showFetchedTasks(tasks)
    }
    
    func interactorDidFetchTasks(_ result: [TaskList]) {
        self.tasks = result
        DispatchQueue.main.async {
            self.view?.showFetchedTasks(result)
        }
        
        result.forEach { task in
            coreDataManager.createTask(title: task.title)
        }
    }
    
    func interactorDidFailFetchTasks(with error: Error) {
        DispatchQueue.main.async {
            self.view?.showError(error)
        }
    }
    
    func receiveTask(at index: Int) -> TaskList? {
        guard index < tasks.count else { return nil }
        return tasks[index]
    }

//    func getAllTasks() {
//        let tasks = coreDataService.fetchAllTasks()
//        view?.update(with: tasks)
//    }
    
    func addNewTask(_ title: String) {
        coreDataManager.createTask(title: title)
        storedTasks = coreDataManager.fetchAllTasks()
        view?.showFetchedTasks(tasks)
    }
    
    func updateTheTask(_ task: ToDoList, title: String, isCompleted: Bool, userID: Int) {
        coreDataManager.updateTask(task,
                                   newTitle: title,
                                   isCompleted: isCompleted,
                                   userID: userID
        )
    }
    
    func deleteTask(_ task: ToDoList) {
        coreDataManager.deleteTask(task)
        storedTasks = coreDataManager.fetchAllTasks()
        view?.showFetchedTasks(tasks)
    }
}
