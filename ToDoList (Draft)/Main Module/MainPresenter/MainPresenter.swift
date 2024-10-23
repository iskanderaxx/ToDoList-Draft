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
    var apiTasks: [TaskList] { get set }
    
    func fetchApiTasks()
    func interactorDidFetchTasks(_ result: [TaskList])
    func interactorDidFailFetchTasks(with error: Error)
    func receiveApiTask(at index: Int) -> TaskList?
    func didSelectTask(_ task: ToDoList)

    func getAllTasks()
    func addTask(title: String)
    func deleteTask(_ task: ToDoList)
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouter?
    
    var apiTasks: [TaskList] = []
    var coreDataTasks: [ToDoList] = []
    
    private var coreDataManager = CoreDataManager.shared
    
    init(view: MainViewProtocol) {
        self.view = view
        self.interactor = MainInteractor()
    }
    
    // MARK: - Setup
    
    func fetchApiTasks() {
        interactor?.fetchTasks()
    }
    
    func interactorDidFetchTasks(_ result: [TaskList]) {
        self.apiTasks = result
        
        DispatchQueue.main.async {  
//            self.getAllTasks()
            self.view?.showFetchedTasks(result)
        }
    }
    
    func interactorDidFailFetchTasks(with error: Error) {
        DispatchQueue.main.async {
            self.view?.showError(error)
        }
    }
    
    func receiveApiTask(at index: Int) -> TaskList? { // ToDoList
        guard index < apiTasks.count else { return nil }
        return apiTasks[index]
    }
    
   func didSelectTask(_ task: ToDoList) {
        router?.navigateToDetailScreen(with: task)
    }
    
    // MARK: Converter
    
    private func convertTaskListToToDoList(with tasks: [TaskList]) -> [ToDoList] {
        var toDoTasks: [ToDoList] = []
        
        for task in tasks {
            let toDoTask = ToDoList(context: CoreDataManager.shared.persistentContainer.viewContext)
            toDoTask.id = task.id
            toDoTask.title = task.title
            toDoTask.completed = task.completed
            toDoTask.userID = task.userID
            toDoTasks.append(toDoTask)
        }
        
        CoreDataManager.shared.saveContext()
        return toDoTasks
    }
}

extension MainPresenter {
    
    // MARK: CRUD stack
    
    func getAllTasks() {
        let tasks = coreDataManager.getAllTasks()
        
        DispatchQueue.main.async {
            self.view?.showData(of: tasks)
        }
    }
    
    func addTask(title: String) {
        coreDataManager.createTask(title: title)
//        coreDataManager.saveContext()
        getAllTasks()
    }
    
    func updateTheTask(_ task: ToDoList, title: String) {
        coreDataManager.updateTask(task, newTitle: title)
    }
    
    func deleteTask(_ task: ToDoList) {
        coreDataManager.deleteTask(task)
        getAllTasks()
    }
}
