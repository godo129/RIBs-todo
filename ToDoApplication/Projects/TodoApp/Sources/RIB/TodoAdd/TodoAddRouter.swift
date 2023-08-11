//
//  TodoAddRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoAddInteractable: Interactable {
    var router: TodoAddRouting? { get set }
    var listener: TodoAddListener? { get set }
}

protocol TodoAddViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TodoAddRouter: ViewableRouter<TodoAddInteractable, TodoAddViewControllable>, TodoAddRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TodoAddInteractable, viewController: TodoAddViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
        print(viewController.uiviewController.navigationController)
    }
}
