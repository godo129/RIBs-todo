//
//  TodoCompleteInteractor.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import RxSwift

protocol TodoCompleteRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TodoCompletePresentable: Presentable {
    var listener: TodoCompletePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TodoCompleteListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TodoCompleteInteractor: PresentableInteractor<TodoCompletePresentable>, TodoCompleteInteractable, TodoCompletePresentableListener {

    weak var router: TodoCompleteRouting?
    weak var listener: TodoCompleteListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TodoCompletePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
