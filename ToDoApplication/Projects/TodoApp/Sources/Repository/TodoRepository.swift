//
//  TodoRepository.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import Foundation
import LocalProvider

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
    private let plistProvider: LocalProviderProtocol = PlistProvider<LocalTargetType>()
    private let userDefaultsProvider: LocalProviderProtocol = UserDefaultsProvider<LocalTargetType>()
    private let nsCacheProvider: LocalProviderProtocol = NSCacheProvider<LocalTargetType>()
    
    init(todoProvider: TodoProviderProtocol) {
        self.todoProvider = todoProvider
    }
    
    func getAllTodoList() -> [Todo] {
//        if let nsCachedData = try? nsCacheProvider.read(LocalTargetType.todo()) {
//            return nsCachedData as! [Todo]
//        }
//        if let userDefaultsData = try? userDefaultsProvider.read(LocalTargetType.todo()) {
//            return userDefaultsData as! [Todo]
//        }
        if let plistProvider = try? plistProvider.read(LocalTargetType.todo()) {
            return plistProvider as! [Todo]
        }
        return []
    }
    
    func getCompletTodoList() -> [Todo] {
        return getAllTodoList().filter { $0.isCompleted == true }
    }
    
    func getNotCompletTodoList() -> [Todo] {
        return getAllTodoList().filter { $0.isCompleted == false }
    }
    

    func insertTodo(_ todo: Todo) -> [Todo] {
        var todoList = getAllTodoList()
        todoList.append(todo)
        do {
            try plistProvider.create(LocalTargetType.todo(todoList))
            return getAllTodoList()
        } catch {
            print(error)
            return []
        }
    }
    
    func deleteTodo(_ todo: Todo) -> [Todo]? {
        var todoList = getAllTodoList()
        guard let todoIndex = todoList.firstIndex(where: { $0 == todo }) else { return nil }
        todoList.remove(at: todoIndex)
        do {
            try plistProvider.create(LocalTargetType.todo(todoList))
            return getAllTodoList()
        } catch {
            print(error)
            return nil
        }
    }
    
    func updateTodo(from: Todo, to: Todo) -> [Todo]? {
        var todoList = getAllTodoList()
        guard let todoIndex = todoList.firstIndex(where: { $0 == from }) else { return nil }
        todoList[todoIndex] = to
        do {
            try plistProvider.create(LocalTargetType.todo(todoList))
            return getAllTodoList()
        } catch {
            print(error)
            return nil
        }
    }
    
}
