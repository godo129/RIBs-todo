//
//  TodoBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/08/10.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoDependency: Dependency, TodoCompleteDependency, TodoListDependency, TodoAddDependency {
    var imageRepository: ImageRepositoryProtocol { get }
    var todoRepository: TodoRepositoryProtocol { get }
}

final class TodoComponent: Component<TodoDependency> {
    fileprivate var imageRepository: ImageRepositoryProtocol {
        dependency.imageRepository
    }
    fileprivate var todoRepository: TodoRepositoryProtocol {
        dependency.todoRepository
    }
}

// MARK: - Builder

protocol TodoBuildable: Buildable {
    func build(withListener listener: TodoListener) -> TodoRouting
}

final class TodoBuilder: Builder<TodoDependency>, TodoBuildable {
    

    override init(dependency: TodoDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: TodoListener) -> TodoRouting {
        let component = TodoComponent(dependency: dependency)
        let viewController = TodoViewController.viewControllerInstance() ?? TodoViewController()
        let interactor = TodoInteractor(
            presenter: viewController as! TodoPresentable,
            todoRepository: dependency.todoRepository,
            imageRepository: dependency.imageRepository
        )
        let todoCompleteBuilder = TodoCompleteBuilder(dependency: dependency)
        let todoListBuilder = TodoListBuilder(dependency: dependency)
        let todoAddBuilder = TodoAddBuilder(dependency: dependency)
        interactor.listener = listener
        return TodoRouter(
            interactor: interactor,
            viewController: viewController as! TodoViewControllable,
            todoCompleteBuilder: todoCompleteBuilder,
            todoListBuilder: todoListBuilder,
            todoAddBuilder: todoAddBuilder
        )
    }
    
}
