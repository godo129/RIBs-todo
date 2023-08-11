//
//  TodoListBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TodoListComponent: Component<TodoListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TodoListBuildable: Buildable {
    func build(withListener listener: TodoListListener) -> TodoListRouting
}

final class TodoListBuilder: Builder<TodoListDependency>, TodoListBuildable {

    override init(dependency: TodoListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TodoListListener) -> TodoListRouting {
        let component = TodoListComponent(dependency: dependency)
        let viewController = TodoListViewController.viewControllerInstance() ?? TodoListViewController()
        let interactor = TodoListInteractor(presenter: viewController as! TodoListPresentable)
        interactor.listener = listener
        return TodoListRouter(interactor: interactor, viewController: viewController as! TodoListViewControllable)
    }
}
