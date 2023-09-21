//
//  ProfileViewBuilder.swift
//  ToDoApp
//
//  Created by hong on 2023/09/21.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol ProfileViewDependency: Dependency {
    var imageRepository: ImageRepositoryProtocol { get }
}

final class ProfileViewComponent: Component<ProfileViewDependency> {
    fileprivate var imageRepository: ImageRepositoryProtocol {
        dependency.imageRepository
    }
}

// MARK: - Builder

protocol ProfileViewBuildable: Buildable {
    func build(withListener listener: ProfileViewListener) -> ProfileViewRouting
}

final class ProfileViewBuilder: Builder<ProfileViewDependency>, ProfileViewBuildable {

    override init(dependency: ProfileViewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileViewListener) -> ProfileViewRouting {
        let component = ProfileViewComponent(dependency: dependency)
        let viewController = ProfileViewViewController(imageRepository: component.imageRepository)
        let interactor = ProfileViewInteractor(presenter: viewController, imageRepository: component.imageRepository)
        interactor.listener = listener
        return ProfileViewRouter(interactor: interactor, viewController: viewController)
    }
}
