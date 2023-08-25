//
//  TodoCompleteRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoCompleteInteractable: Interactable, TodoUpdateListener {
    var router: TodoCompleteRouting? { get set }
    var listener: TodoCompleteListener? { get set }
}

protocol TodoCompleteViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TodoCompleteRouter: ViewableRouter<TodoCompleteInteractable, TodoCompleteViewControllable>, TodoCompleteRouting {

    private let todoUpdateBuilder: TodoUpdateBuildable
    
    init(
        interactor: TodoCompleteInteractable,
        viewController: TodoCompleteViewControllable,
        todoUpdateBuilder: TodoUpdateBuildable
    ) {
        self.todoUpdateBuilder = todoUpdateBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToUpdate(todo: Todo? = nil) {
        let todoUpdateBuilder = todoUpdateBuilder.build(withListener: interactor, todo: todo)
        attachChild(todoUpdateBuilder)
        viewControllable.uiviewController.navigationController?.pushViewController(todoUpdateBuilder.viewControllable.uiviewController, animated: true)
    }
}
