//
//  TodoRepository.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import Foundation

protocol TodoRepositoryProtocol {
    func getAllTodoList() -> [Todo]
    func getCompletTodoList() -> [Todo]
    func getNotCompletTodoList() -> [Todo]
    func insertTodo(_ todo: Todo) -> [Todo]
    func deleteTodo(_ todo: Todo) -> [Todo]?
    func updateTodo(from: Todo, to: Todo) -> [Todo]?
}

struct TodoRepository: TodoRepositoryProtocol {
    
    private let todoProvider: TodoProviderProtocol
    
    init(todoProvider: TodoProviderProtocol) {
        self.todoProvider = todoProvider
    }
    
    func getAllTodoList() -> [Todo] {
        return todoProvider.getTodoList()
    }
    
    func getCompletTodoList() -> [Todo] {
        return todoProvider.getTodoList().filter { $0.isCompleted == true }
    }
    
    func getNotCompletTodoList() -> [Todo] {
        return todoProvider.getTodoList().filter { $0.isCompleted == false }
    }
    
    @discardableResult
    func insertTodo(_ todo: Todo) -> [Todo] {
        return todoProvider.insert(todo: todo)
    }
    
    func deleteTodo(_ todo: Todo) -> [Todo]? {
        return todoProvider.delete(todo: todo)
    }
    
    func updateTodo(from: Todo, to: Todo) -> [Todo]? {
        return todoProvider.update(from: from, to: to)
    }
    
}
