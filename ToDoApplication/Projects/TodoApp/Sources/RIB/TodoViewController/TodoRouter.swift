//
//  TodoRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/08/10.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoInteractable: Interactable, TodoCompleteListener, TodoListListener, TodoAddListener {
    var router: TodoRouting? { get set }
    var listener: TodoListener? { get set }
}

protocol TodoViewControllable: ViewControllable {

}

final class TodoRouter: ViewableRouter<TodoInteractable, TodoViewControllable>, TodoRouting {

    private let todoCompleteBuilder: TodoCompleteBuildable
    private let todoListBuilder: TodoListBuildable
    private let todoAddBuilder: TodoAddBuildable
    
    init(
        interactor: TodoInteractable,
        viewController: TodoViewControllable,
        todoCompleteBuilder: TodoCompleteBuildable,
        todoListBuilder: TodoListBuildable,
        todoAddBuilder: TodoAddBuildable
    ) {
        self.todoCompleteBuilder = todoCompleteBuilder
        self.todoListBuilder = todoListBuilder
        self.todoAddBuilder = todoAddBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToCompleList() {
        let todoCompleRouter = todoCompleteBuilder.build(withListener: interactor)
        attachChild(todoCompleRouter)
        viewController.uiviewController.navigationController?.pushViewController(todoCompleRouter.viewControllable.uiviewController, animated: true)
    }
    
    func routeToTodoList() {
        let todoListRouter = todoListBuilder.build(withListener: interactor)
        attachChild(todoListRouter)
        viewController.uiviewController.navigationController?.pushViewController(todoListRouter.viewControllable.uiviewController, animated: true)
    }
    
    func routeToTodoAdd() {
        let todoAddRouter = todoAddBuilder.build(withListener: interactor)
        attachChild(todoAddRouter)
        viewController.uiviewController.navigationController?.pushViewController(todoAddRouter.viewControllable.uiviewController, animated: true)
    }
    
}
