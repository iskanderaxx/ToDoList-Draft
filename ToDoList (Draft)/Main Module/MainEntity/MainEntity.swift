//
//  MainEntity.swift
//  ToDoList (Draft)
//
//  Created by Mac Alexander on 25.08.2024.
//

import Foundation

struct TaskList: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let isCompleted: Bool
    let date: Date?
}
