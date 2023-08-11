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

final class RootViewController: UINavigationController, RootViewControllable {
   
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
        let todoBuilder = TodoBuilder(dependency: dependency)
        let viewController = RootViewController(root: EmpthyViewController())
        return RootRouter(interactor: interactor, todoBuilder: todoBuilder, viewController: viewController)
    }
}
