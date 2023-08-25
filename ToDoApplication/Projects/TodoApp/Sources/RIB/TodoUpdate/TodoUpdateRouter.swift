//
//  TodoUpdateRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/08/25.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol TodoUpdateInteractable: Interactable {
    var router: TodoUpdateRouting? { get set }
    var listener: TodoUpdateListener? { get set }
}

protocol TodoUpdateViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TodoUpdateRouter: ViewableRouter<TodoUpdateInteractable, TodoUpdateViewControllable>, TodoUpdateRouting {
    
    func backward() {
        self.viewControllable.uiviewController.navigationController?.popViewController(animated: true)
    }

    override init(
        interactor: TodoUpdateInteractable,
        viewController: TodoUpdateViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
