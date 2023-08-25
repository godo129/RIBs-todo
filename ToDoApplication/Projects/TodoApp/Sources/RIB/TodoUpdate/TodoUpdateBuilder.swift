//
//  TodoUpdateBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/08/25.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoUpdateDependency: Dependency {
    var todoRepository: TodoRepositoryProtocol { get }
    var imageRepository: ImageRepositoryProtocol { get }
}

final class TodoUpdateComponent: Component<TodoUpdateDependency> {

    fileprivate var todoRepositorty: TodoRepositoryProtocol {
        dependency.todoRepository
    }
    fileprivate var imageRepository: ImageRepositoryProtocol {
        dependency.imageRepository
    }
}

// MARK: - Builder

protocol TodoUpdateBuildable: Buildable {
    func build(withListener listener: TodoUpdateListener, todo: Todo?) -> TodoUpdateRouting
}

final class TodoUpdateBuilder: Builder<TodoUpdateDependency>, TodoUpdateBuildable {

    override init(dependency: TodoUpdateDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: TodoUpdateListener,
        todo: Todo? = nil
    ) -> TodoUpdateRouting {
        let component = TodoUpdateComponent(dependency: dependency)
        let viewController = TodoUpdateViewController(todo: todo)
        let interactor = TodoUpdateInteractor(
            presenter: viewController,
            todoRepository: component.todoRepositorty,
            imageRepository: component.imageRepository
        )
        interactor.listener = listener
        return TodoUpdateRouter(interactor: interactor, viewController: viewController)
    }
}
