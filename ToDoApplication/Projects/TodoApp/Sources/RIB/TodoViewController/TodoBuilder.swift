//
//  TodoBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/08/10.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoDependency: Dependency, TodoCompleteDependency, TodoListDependency, TodoAddDependency {
}

final class TodoComponent: Component<TodoDependency> {
    
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
        let interactor = TodoInteractor(presenter: viewController as! TodoPresentable)
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
