//
//  TodoInteractor.swift
//  ToDoApp
//
//  Created by hong on 2023/08/10.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import RxSwift

protocol TodoRouting: ViewableRouting {
    func routeToCompleList()
    func routeToTodoList()
    func routeToTodoAdd()
}

protocol TodoPresentable: Presentable {
    var listener: TodoPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TodoListener: AnyObject {

}

final class TodoInteractor: PresentableInteractor<TodoPresentable>, TodoInteractable, TodoPresentableListener {
    
    var completedTodos = PublishSubject<[Todo]>()
    var notCompletedTodos = PublishSubject<[Todo]>()

    weak var router: TodoRouting?
    weak var listener: TodoListener?
    
    private let todoRepository = TodoRepository(todoProvider: TodoProvider.instance)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.

    override init(presenter: TodoPresentable) {
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
    
    func viewWillAppear() {
        completedTodos.on(.next(todoRepository.getCompletTodoList()))
        notCompletedTodos.on(.next(todoRepository.getNotCompletTodoList()))
    }
    
    func completeListButtonTapped() {
        router?.routeToCompleList()
    }
    
    func todoListAddButtonTapped() {
        router?.routeToTodoAdd()
    }
    
    func todoListButtonTapped() {
        router?.routeToTodoList()
    }

}
