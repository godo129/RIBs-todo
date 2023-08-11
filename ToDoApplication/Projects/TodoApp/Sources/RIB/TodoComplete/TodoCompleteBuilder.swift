//
//  TodoCompleteBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoCompleteDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TodoCompleteComponent: Component<TodoCompleteDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TodoCompleteBuildable: Buildable {
    func build(withListener listener: TodoCompleteListener) -> TodoCompleteRouting
}

final class TodoCompleteBuilder: Builder<TodoCompleteDependency>, TodoCompleteBuildable {

    override init(dependency: TodoCompleteDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TodoCompleteListener) -> TodoCompleteRouting {
        let component = TodoCompleteComponent(dependency: dependency)
        let viewController = TodoCompleteViewController.viewControllerInstance() ?? TodoCompleteViewController()
        let interactor = TodoCompleteInteractor(presenter: viewController as! TodoCompletePresentable)
        interactor.listener = listener
        return TodoCompleteRouter(interactor: interactor, viewController: viewController as! TodoCompleteViewControllable)
    }
}
