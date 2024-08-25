//
//  MainPresenter.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit

protocol MainPresenterProtocol {
    var view: MainViewProtocol? { get set } // Shall have references to View, Interactor & Router
    var interactor: MainInteractorProtocol? { get set }
    var router: MainRouter? { get set }
    
    func viewDidLoad()
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
    
    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func interactorDidFetchTasks(_ result: [TaskList]) { // with result: Result<[TaskList], Error>
        DispatchQueue.main.async {
            self.view?.showFetchedTasks(result)
        }
//        switch result {
//        case .success(let tasks):
//            view?.update(with: tasks)
//        case .failure:
//            view?.update(with: FetchError.failed)
//        }
    }
    
    func interactorDidFailFetchTasks(with error: Error) {
        DispatchQueue.main.async {
            self.view?.showError(error)
        }
    }
//    
//    func getAllTasks() {
//        let tasks = coreDataService.fetchAllTasks()
//        view?.update(with: tasks)
//    }
//    
//    func addNewTask(title: String) {
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
}
