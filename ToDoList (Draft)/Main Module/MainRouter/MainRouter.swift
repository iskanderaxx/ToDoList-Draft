//
//  MainRouter.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import UIKit

typealias EntryPoint = AnyView & UIViewController

// Router contains protocol+object and entryPoint
protocol AnyRouter {
    var entryPoint: EntryPoint? { get }
    static func start() -> AnyRouter
}

final class UserRouter: AnyRouter {
    var entryPoint: EntryPoint?
    
    static func start() -> AnyRouter {
        let router = UserRouter()
        
        let view = UserView()
        let interactor = UserInteractor()
        let presenter = UserPresenter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.entryPoint = view
        
        return router
    }
}
