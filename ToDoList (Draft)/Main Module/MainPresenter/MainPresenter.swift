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
    func receiveTask(at index: Int) -> TaskList?
    func interactorDidFetchTasks(_ result: [TaskList])
    func interactorDidFailFetchTasks(with error: Error)
//    func getAllTasks()
//    func addNewTask(title: String)
//    func updateTheTask(_ task: TaskList, title: String, contents: String, isCompleted: Bool, date: Date)
//    func deleteTask(_ task: TaskList)
}

// Доработать enum
enum FetchError: Error {
    case failed
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    //    private var coreDataService = CoreDataManager.shared
    var interactor: MainInteractorProtocol?
    var router: MainRouter?
    private var tasks: [TaskList] = []
    
    var tasksCount: Int {
        return tasks.count
    }
    
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
}
//
//    func getAllTasks() {
//        let tasks = coreDataService.fetchAllTasks()
//        view?.update(with: tasks)
//    }
//    
//    func addNewTask(_ toDo: String) {
//        coreDataService.createTask(title: title)
//        getAllTasks()
//    }
//    
//    func updateTheTask(_ task: TaskList, title: String, contents: String, isCompleted: Bool, date: Date) {
//        coreDataService.updateTask(task, newTitle: title, newContents: contents, isCompleted: isCompleted, newDate: date)
//    }
//    
//    func deleteTask(_ task: TaskList) {
//        coreDataService.deleteTask(task)
//        getAllTasks()
//    }

