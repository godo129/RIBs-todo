//
//  TodoAddBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoAddDependency: Dependency {
    var todoRepository: TodoRepositoryProtocol { get }
    var imageRepository: ImageRepositoryProtocol { get }
}

final class TodoAddComponent: Component<TodoAddDependency> {
    fileprivate var todoRepositorty: TodoRepositoryProtocol {
        dependency.todoRepository
    }
    fileprivate var imageRepository: ImageRepositoryProtocol {
        dependency.imageRepository
    }
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
        let interactor = TodoAddInteractor(
            presenter: viewController as! TodoAddPresentable,
            todoRepository: component.todoRepositorty,
            imageRepository: component.imageRepository
        )
        interactor.listener = listener
        return TodoAddRouter(interactor: interactor, viewController: viewController as! TodoAddViewControllable)
    }
}
