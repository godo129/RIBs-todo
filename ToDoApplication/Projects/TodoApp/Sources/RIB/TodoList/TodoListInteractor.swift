//
//  TodoListInteractor.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import RxSwift

protocol TodoListRouting: ViewableRouting {
    func routeToUpdate(_ todo: Todo?)
}

protocol TodoListPresentable: Presentable {
    var listener: TodoListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TodoListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TodoListInteractor: PresentableInteractor<TodoListPresentable>, TodoListInteractable, TodoListPresentableListener {

    weak var router: TodoListRouting?
    weak var listener: TodoListListener?
    private let todoRepository: TodoRepositoryProtocol
    var fetchedTodos: PublishSubject<[Todo]> = .init()
    
    init(
        presenter: TodoListPresentable,
        todoRepository: TodoRepositoryProtocol
    ) {
        self.todoRepository = todoRepository
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
    
    func todoStatusChagned(from: Todo, to: Todo) {
        dump(todoRepository.updateTodo(from: from, to: to))
    }
    
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        fetchedTodos.on(.next(todoRepository.getNotCompletTodoList()))
    }
    
    func todoCellTouched(_ todo: Todo?) {
        router?.routeToUpdate(todo)
    }
}
