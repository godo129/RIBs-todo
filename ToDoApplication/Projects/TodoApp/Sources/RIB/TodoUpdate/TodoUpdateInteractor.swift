//
//  TodoUpdateInteractor.swift
//  ToDoApp
//
//  Created by hong on 2023/08/25.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import RxSwift
import Foundation

protocol TodoUpdateRouting: ViewableRouting {
    func backward()
}

protocol TodoUpdatePresentable: Presentable {
    var listener: TodoUpdatePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TodoUpdateListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TodoUpdateInteractor: PresentableInteractor<TodoUpdatePresentable>, TodoUpdateInteractable, TodoUpdatePresentableListener {

    private let todoRepository: TodoRepositoryProtocol
    private let imageRepository: ImageRepositoryProtocol
    var imageData: PublishSubject<Data> = .init()
    var imageFetchErrorOcurred: PublishSubject<String> = .init()
    var dateData: PublishSubject<Date> = .init()
    var datePickerErrorOcurred: PublishSubject<String> = .init()
    
    weak var router: TodoUpdateRouting?
    weak var listener: TodoUpdateListener?

    init(
        presenter: TodoUpdatePresentable,
        todoRepository: TodoRepositoryProtocol,
        imageRepository: ImageRepositoryProtocol
    ) {
        self.todoRepository = todoRepository
        self.imageRepository = imageRepository
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
    
    func viewDidLoad() {
        
    }
    
    func todoDelete(_ todo: Todo) {
        dump(todoRepository.deleteTodo(todo))
        router?.backward()
    }
    
    func todoUpdate(from: Todo, to: Todo) {
        dump(todoRepository.updateTodo(from: from, to: to))
        router?.backward()
    }
    
    func photoSelectButtonTapped() {
        Task {
            do {
                guard let viewController = router?.viewControllable.uiviewController else {
                    imageFetchErrorOcurred.on(.next("이미지 선택에 오류가 발생했습니다."))
                    return
                }
                let imageDataValue = try await imageRepository.getPngData(viewController)
                imageData.on(.next(imageDataValue))
            } catch {
                imageFetchErrorOcurred.on(.next(error.localizedDescription))
            }
        }
    }
    
    func datePickButtonTapped(selectedDate: Date) {
        guard let viewController = router?.viewControllable.uiviewController,
            let datePicker = DatePickerViewController.viewControllerInstance() as? DatePickerViewController else {
            datePickerErrorOcurred.on(.next("날짜 선택에 오류가 발생했습니다."))
            return
        }
        datePicker.selectedDate = selectedDate
        datePicker.date = { [weak self] date in
            self?.dateData.on(.next(date))
        }
        viewController.present(datePicker, animated: true)
    }
}
