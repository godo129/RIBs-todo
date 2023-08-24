//
//  TodoProvider.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import Foundation

protocol TodoProviderProtocol {
    func getTodoList() -> [Todo]
    func delete(todo: Todo) -> [Todo]?
    func insert(todo: Todo) -> [Todo]
    func update(from: Todo, to: Todo) -> [Todo]?
}

final class TodoProvider: TodoProviderProtocol {
    
    static let instance = TodoProvider()
    private var todoList: [Todo] = []
    private init() {}
    
    func getTodoList() -> [Todo] {
        return todoList
    }
    
    func delete(todo: Todo) -> [Todo]? {
        guard let indexOfTodo = todoList.firstIndex(where: { $0 === todo }) else {return nil}
        todoList.remove(at: indexOfTodo)
        return todoList
    }
    
    func insert(todo: Todo) -> [Todo] {
        todoList.append(todo)
        return todoList
    }
    
    func update(from: Todo, to: Todo) -> [Todo]? {
        guard let indexOfTodo = todoList.firstIndex(where: { $0 === from }) else {return nil}
        todoList[indexOfTodo] = to
        return todoList
    }
}
