//
//  MainRouter.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit

typealias EntryPoint = MainViewProtocol & UIViewController

protocol MainRouterProtocol {
    var entryPoint: EntryPoint? { get }
    static func start() -> MainRouterProtocol
    
    func navigateToDetailScreen(with task: ToDoList)
}

final class MainRouter: MainRouterProtocol {
    var entryPoint: EntryPoint?
    
    static func start() -> MainRouterProtocol {
        let router = MainRouter()
        
        let view = MainViewController()
        let interactor = MainInteractor()
        let presenter = MainPresenter(view: view)
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.entryPoint = view
        
        return router
    }
    
    func navigateToDetailScreen(with task: ToDoList) {
        let detailViewController = DetailViewController(coreDataTask: task)
        entryPoint?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
