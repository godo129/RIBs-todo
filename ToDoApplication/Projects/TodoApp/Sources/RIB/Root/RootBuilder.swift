//
//  RootBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import UIKit

protocol RootDependency: Dependency, TodoDependency {

}

final class RootComponent: Component<RootDependency> {

}

final class RootViewController: UITabBarController, RootViewControllable {
   
}

final class EmpthyViewController: UIViewController, ViewControllable {}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let interactor = RootInteractor()
        let todoBuilder = TodoBuilder(dependency: component.dependency)
        let profileBuilder = ProfileViewBuilder(dependency: component.dependency)
        let tabBarController = RootViewController()
        return RootRouter(interactor: interactor, todoBuilder: todoBuilder, profileBuilder: profileBuilder, viewController: tabBarController)
    }
}
