//
//  ProfileViewInteractor.swift
//  ToDoApp
//
//  Created by hong on 2023/09/21.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import RxSwift

protocol ProfileViewRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileViewPresentable: Presentable {
    var listener: ProfileViewPresentableListener? { get set }
}

protocol ProfileViewListener: AnyObject {
}

final class ProfileViewInteractor: PresentableInteractor<ProfileViewPresentable>, ProfileViewInteractable, ProfileViewPresentableListener {

    weak var router: ProfileViewRouting?
    weak var listener: ProfileViewListener?
    private let imageRepository: ImageRepositoryProtocol

    init(
        presenter: ProfileViewPresentable,
        imageRepository: ImageRepositoryProtocol
    ) {
        self.imageRepository = imageRepository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
