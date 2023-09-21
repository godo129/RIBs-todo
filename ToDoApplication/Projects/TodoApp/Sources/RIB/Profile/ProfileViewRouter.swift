//
//  ProfileViewRouter.swift
//  ToDoApp
//
//  Created by hong on 2023/09/21.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs

protocol ProfileViewInteractable: Interactable {
    var router: ProfileViewRouting? { get set }
    var listener: ProfileViewListener? { get set }
}

protocol ProfileViewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileViewRouter: ViewableRouter<ProfileViewInteractable, ProfileViewViewControllable>, ProfileViewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileViewInteractable, viewController: ProfileViewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
