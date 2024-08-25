//
//  MainEntity.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import Foundation

struct TaskResponse: Codable {
    let todos: [TaskList]
}

struct TaskList: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
