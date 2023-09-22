//
//  RootRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, TodoListener, ProfileViewListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    private let rootViewController: UITabBarController
    private let todoBuilder: TodoBuildable
    private let profileBuilder: ProfileViewBuildable
    init(
        interactor: RootInteractable,
        todoBuilder: TodoBuildable,
        profileBuilder: ProfileViewBuildable,
        viewController: RootViewControllable
    ) {
        self.todoBuilder = todoBuilder
        self.profileBuilder = profileBuilder
        self.rootViewController = viewController as! UITabBarController
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func cleanupViews() {
        
    }

    override func didLoad() {
        super.didLoad()
        start()
    }

    func start() {
        let profileTab = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 1)
        let profileNavigationController = UINavigationController(rootViewController: EmpthyViewController())
        profileNavigationController.tabBarItem = profileTab
        
        let todoTab = UITabBarItem(title: nil, image: UIImage(systemName: "calendar"), tag: 0)
        let todoNavigationController = UINavigationController(rootViewController: EmpthyViewController())
        todoNavigationController.tabBarItem = todoTab
        let todoRouter = todoBuilder.build(withListener: interactor)
        let todoView = todoRouter.viewControllable as! UIViewController
        todoNavigationController.viewControllers = [todoView]
        todoNavigationController.navigationBar.tintColor = .black
        
        let profileRouter = profileBuilder.build(withListener: interactor)
        let profileView = profileRouter.viewControllable as! UIViewController
        profileNavigationController.viewControllers = [profileView]
        profileNavigationController.navigationBar.tintColor = .black

        let tabBarController = rootViewController
        tabBarController.viewControllers = [todoNavigationController, profileNavigationController]
        
        attachChild(todoRouter)
        attachChild(profileRouter)
    }
}
