//
//  TodoCompleteRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoCompleteInteractable: Interactable {
    var router: TodoCompleteRouting? { get set }
    var listener: TodoCompleteListener? { get set }
}

protocol TodoCompleteViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TodoCompleteRouter: ViewableRouter<TodoCompleteInteractable, TodoCompleteViewControllable>, TodoCompleteRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TodoCompleteInteractable, viewController: TodoCompleteViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
