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
    
    var tasksCount: Int { get }
    
    func viewDidLoad()
    func interactorDidFetchTasks(_ result: [TaskList])
    func interactorDidFailFetchTasks(with error: Error)
    func receiveTask(at index: Int) -> TaskList?

    func addNewTask(_ title: String)
    func updateTheTask(_ task: ToDoList, title: String)
    func deleteTask(_ task: ToDoList)
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouter?
    
    private var tasks: [TaskList] = []
    private var coreDataTasks: [ToDoList] = [] // New
    private var coreDataManager = CoreDataManager.shared
    
    var tasksCount: Int { tasks.count + coreDataTasks.count }
    
    // MARK: - Setup
    
    // Проблема возникает в презентере на этапе попытки впихнуть методы СД в фэтчинг - их надо делить
    func viewDidLoad() { // изменить странное название
        interactor?.fetchTasks()
//        fetchAndShowTasks() // New
    }
    
    func interactorDidFetchTasks(_ result: [TaskList]) {
        self.tasks = result
//        saveTasksToCoreData(result) // New
//        fetchAndShowTasks()
        DispatchQueue.main.async {
            self.view?.showFetchedTasks(result)
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
    
    func addNewTask(_ title: String) {
        coreDataManager.createTask(title: title)
    }
    
    func updateTheTask(_ task: ToDoList, title: String) {
        coreDataManager.updateTask(task, 
                                   newTitle: title
        )
//        fetchAndShowTasks()
    }
    
    func deleteTask(_ task: ToDoList) {
        coreDataManager.deleteTask(task)
//        fetchAndShowTasks()
    }
    
    // MARK: - Helping functions
    
    private func fetchAndShowTasks() {
        let coreDataTasks = coreDataManager.getAllTasks()
        let allTasks = tasks + coreDataTasks.map {
            TaskList(id: $0.userID,
                     title: $0.title ?? "",
                     completed: $0.completed,
                     userID: $0.userID
            )
        }
        DispatchQueue.main.async {
            self.view?.showFetchedTasks(allTasks)
        }
    }
    
    private func saveTasksToCoreData(_ tasks: [TaskList]) {
        tasks.forEach { task in
            coreDataManager.createTask(title: task.title)
        }
    }
}
