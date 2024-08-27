//
//  DetailPresenter.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import CoreData

final class DetailPresenter {
    private let task: ToDoList
    private let coreDataManager: CoreDataManager
    
    init(task: ToDoList, coreDataManager: CoreDataManager) {
        self.task = task
        self.coreDataManager = coreDataManager
    }
    
    func getTaskId() -> Int { Int(task.id) }
    
    func getTaskTitle() -> String { task.title ?? "" }
    
    func getTaskStatus() -> Bool { task.completed }
    
    func getTaskUserUID() -> Int { Int(task.userID) }
    
    func setTaskId(_ id: Int) { task.id = id }
    
    func setTaskTitle(_ title: String) { task.title = title }
    
    func setTaskStatus(_ isCompleted: Bool) { task.completed = isCompleted}
    
    func setTaskUserID(_ userID: Int) { task.userID = userID }
    
//    func updateTask(id: Int, title: String, isCompleted: Bool, userID: Int) {
//        if let id = id { setTaskId(id) }
//        if let title = dateOfBirth { setMemberDateOfBirth(dateOfBirth) }
//        if let completed = gender { setMemberGender(gender) }
//        if let userID = song { setMemberSong(song) }
//        
//        coreDataManager.saveContext()
//    }
}
