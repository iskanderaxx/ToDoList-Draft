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
    
    var presenter: MainPresenterProtocol?
    private var coreDataManager = CoreDataManager.shared
    
    func fetchTasks() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                self?.presenter?.interactorDidFailFetchTasks(with: error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let taskResponse = try JSONDecoder().decode(TaskResponse.self, from: data)
//                print("Fetched tasks: \(taskResponse.todos)")
                self?.presenter?.interactorDidFetchTasks(taskResponse.todos)
            } catch {
                self?.presenter?.interactorDidFailFetchTasks(with: error)
            }
        }
        task.resume()
    }
}
