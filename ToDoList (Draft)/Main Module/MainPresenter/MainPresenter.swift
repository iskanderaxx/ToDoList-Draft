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
    func updateTheTask(_ task: ToDoList, title: String, isCompleted: Bool, userID: Int)
    func deleteTask(_ task: ToDoList)
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouter?
    
    private var tasks: [TaskList] = []
    private var coreDataManager = CoreDataManager.shared
    
    var tasksCount: Int { tasks.count }
    
    // MARK: - Setup
    
    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func interactorDidFetchTasks(_ result: [TaskList]) {
        self.tasks = result
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
    
    func updateTheTask(_ task: ToDoList, title: String, isCompleted: Bool, userID: Int) {
        coreDataManager.updateTask(task, newTitle: title, isCompleted: isCompleted, userID: userID)
    }
    
    func deleteTask(_ task: ToDoList) {
        coreDataManager.deleteTask(task)
    }
}
