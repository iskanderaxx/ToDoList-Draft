//
//  MainPresenter.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit

protocol MainPresenterProtocol {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorProtocol? { get set }
    var router: MainRouter? { get set }
    
    var coreDataTasks: [ToDoList] { get set }
//    var tasksCount: Int { get }
    
    func fetchTasksFromApi()
    func interactorDidFetchTasks(_ result: [TaskList])
    func interactorDidFailFetchTasks(with error: Error)
    func receiveTask(at index: Int) -> TaskList?

    func getAllTasks()
    func addTask(title: String)
    func updateTheTask(_ task: ToDoList, title: String)
    func deleteTask(_ task: ToDoList)
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouter?
    
    private var tasks: [TaskList] = []
    var coreDataTasks: [ToDoList] = []
    private var coreDataManager = CoreDataManager.shared
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
//    var tasksCount: Int { tasks.count + coreDataTasks.count }
    
    // MARK: - Setup
    
    func fetchTasksFromApi() {
        interactor?.fetchTasks()
    }
    
    func interactorDidFetchTasks(_ result: [TaskList]) {
        self.tasks = result
        
//        DispatchQueue.main.async {
//            self.view?.showFetchedTasks(result)
//        }
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
    
    // MARK: CRUD stack
    
    func getAllTasks() {
        let tasks = coreDataManager.getAllTasks()
        view?.showData(of: tasks)
    }
    
    func addTask(title: String) {
        coreDataManager.createTask(title: title)
        getAllTasks()
    }
    
    func updateTheTask(_ task: ToDoList, title: String) {
        coreDataManager.updateTask(task, newTitle: title)
    }
    
    func deleteTask(_ task: ToDoList) {
        coreDataManager.deleteTask(task)
        getAllTasks()
    }
    
    // MARK: - Helping functions
    
//    private func fetchAndShowTasks() {
//        let coreDataTasks = coreDataManager.getAllTasks()
//        let allTasks = tasks + coreDataTasks.map {
//            TaskList(id: Int($0.userID),
//                     title: $0.title ?? "",
//                     completed: $0.completed,
//                     userID: Int($0.userID)
//            )
//        }
//        DispatchQueue.main.async {
//            self.view?.showFetchedTasks(allTasks)
//        }
//    }
//    
//    private func saveTasksToCoreData(_ tasks: [TaskList]) {
//        tasks.forEach { task in
//            coreDataManager.createTask(title: task.title)
//        }
//    }
}
