//
//  TodoListRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoListInteractable: Interactable, TodoUpdateListener {
    var router: TodoListRouting? { get set }
    var listener: TodoListListener? { get set }
}

protocol TodoListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TodoListRouter: ViewableRouter<TodoListInteractable, TodoListViewControllable>, TodoListRouting {

    private let todoUpdateBuilder: TodoUpdateBuildable
    
    init(
        interactor: TodoListInteractable,
        viewController: TodoListViewControllable,
        todoUpdateBuilder: TodoUpdateBuildable
    ) {
        self.todoUpdateBuilder = todoUpdateBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToUpdate(_ todo: Todo? = nil) {
        let todoUpdateBuilder = todoUpdateBuilder.build(withListener: interactor, todo: todo)
        attachChild(todoUpdateBuilder)
        viewControllable.uiviewController.navigationController?.pushViewController(todoUpdateBuilder.viewControllable.uiviewController, animated: true)
    }
}
