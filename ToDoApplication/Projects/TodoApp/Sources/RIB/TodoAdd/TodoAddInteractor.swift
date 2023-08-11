//
//  TodoAddInteractor.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import RxSwift
import Foundation

protocol TodoAddRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TodoAddPresentable: Presentable {
    var listener: TodoAddPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TodoAddListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TodoAddInteractor: PresentableInteractor<TodoAddPresentable>, TodoAddInteractable, TodoAddPresentableListener {
    
    private let todoRepository: TodoRepositoryProtocol = TodoRepository(todoProvider: TodoProvider.instance)
    private let imageProvider: ImageProvider = .init()
    
    var imageData: PublishSubject<Data> = .init()
    var imageFetchErrorOcurred: PublishSubject<String> = .init()
    var dateData: PublishSubject<Date> = .init()
    var datePickerErrorOcurred: PublishSubject<String> = .init()

    weak var router: TodoAddRouting?
    weak var listener: TodoAddListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TodoAddPresentable) {
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
    
    func saveButtonTapped(todo: Todo) {
        dump(todoRepository.insertTodo(todo))
        router?.interactable.deactivate()
        router?.viewControllable.uiviewController.navigationController?.popViewController(animated: true)
    }
    
    func photoSelectButtonTapped() {
        Task {
            do {
                guard let viewController = router?.viewControllable.uiviewController else {
                    imageFetchErrorOcurred.on(.next("이미지 선택에 오류가 발생했습니다."))
                    return
                }
                let imageDataValue = try await imageProvider.pickImage(viewController)
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
