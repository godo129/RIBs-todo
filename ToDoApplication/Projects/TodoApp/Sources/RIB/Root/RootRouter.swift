//
//  RootRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, TodoListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let rootViewController: UINavigationController
    private let todoBuilder: TodoBuildable
    init(
        interactor: RootInteractable,
        todoBuilder: TodoBuildable,
        viewController: RootViewControllable
    ) {
        self.todoBuilder = todoBuilder
        self.rootViewController = viewController as! UINavigationController
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func cleanupViews() {
        
    }

    override func didLoad() {
        super.didLoad()
        routeToToDo()
    }
    
    func routeToToDo() {
        let todoRouter = todoBuilder.build(withListener: interactor)
        attachChild(todoRouter)
        rootViewController.pushViewController(todoRouter.viewControllable.uiviewController, animated: true)
    }

}
