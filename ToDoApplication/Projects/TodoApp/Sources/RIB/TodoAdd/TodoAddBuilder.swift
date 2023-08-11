//
//  TodoAddBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoAddDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TodoAddComponent: Component<TodoAddDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TodoAddBuildable: Buildable {
    func build(withListener listener: TodoAddListener) -> TodoAddRouting
}

final class TodoAddBuilder: Builder<TodoAddDependency>, TodoAddBuildable {

    override init(dependency: TodoAddDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TodoAddListener) -> TodoAddRouting {
        let component = TodoAddComponent(dependency: dependency)
        let viewController = TodoAddViewController.viewControllerInstance() ?? TodoAddViewController()
        let interactor = TodoAddInteractor(presenter: viewController as! TodoAddPresentable)
        interactor.listener = listener
        return TodoAddRouter(interactor: interactor, viewController: viewController as! TodoAddViewControllable)
    }
}
