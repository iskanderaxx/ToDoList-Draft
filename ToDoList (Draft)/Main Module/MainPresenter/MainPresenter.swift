//
//  MainPresenter.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit

protocol AnyPresenter {
    var view: AnyView? { get set } // Shall have references to View, Interactor & Router
    var interactor: AnyInteractor? { get set }
    var router: AnyRouter? { get set }
    
    func interactorDidFetchTasks(with result: Result<[TaskList], Error>)
    func fetchTasks()
    func getAllTasks()
    func addNewTask(title: String)
    func updateTheTask(_ task: TaskList, title: String, contents: String, isCompleted: Bool, date: Date)
    func deleteTask(_ task: TaskList)
}

// Доработать enum
enum FetchError: Error {
    case failed
}

final class UserPresenter: AnyPresenter {
    weak var view: AnyView?
    private var coreDataService = CoreDataManager.shared
    
    var interactor: AnyInteractor?
    var router: AnyRouter?
    
    func fetchTasks() {
        interactor?.fetchTasks()
    }
    
    func interactorDidFetchTasks(with result: Result<[TaskList], Error>) {
        switch result {
        case .success(let tasks):
            view?.update(with: tasks)
        case .failure:
            view?.update(with: FetchError.failed)
        }
    }
    
    func getAllTasks() {
        let tasks = coreDataService.fetchAllTasks()
        view?.update(with: tasks)
    }
    
    func addNewTask(title: String) {
        coreDataService.createTask(title: title)
        getAllTasks()
    }
    
    func updateTheTask(_ task: TaskList, title: String, contents: String, isCompleted: Bool, date: Date) {
        coreDataService.updateTask(task, newTitle: title, newContents: contents, isCompleted: isCompleted, newDate: date)
    }
    
    func deleteTask(_ task: TaskList) {
        coreDataService.deleteTask(task)
        getAllTasks()
    }
}
