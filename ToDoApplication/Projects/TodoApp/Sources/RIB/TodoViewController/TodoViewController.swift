//
//  TodoViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/07/31.
//

import UIKit
import RxSwift
import RIBs

protocol TodoPresentableListener: AnyObject {
    var completedTodos: PublishSubject<[Todo]> { get }
    var notCompletedTodos: PublishSubject<[Todo]> { get }
    func viewWillAppear()
    func completeListButtonTapped()
    func todoListButtonTapped()
    func todoListAddButtonTapped() 
}

final class TodoViewController: UIViewController, TodoPresentable, TodoViewControllable, ViewControllerInitiable {

    @IBOutlet weak var notCompleListButton: UIButton!
    weak var listener: TodoPresentableListener?
    private let disposeBag = DisposeBag()
    @IBOutlet weak var completListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(todoAddNavigationBarButtonTapped))
        navigationItem.hidesBackButton = true
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener?.viewWillAppear()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if let todoListViewController = segue.destination as? TodoListViewController {
//            // DI
//        }
//        if let todoCompleteViewController = segue.destination as? TodoCompleteViewController {
//            // DI
//        }
//    }
    
    @objc func todoAddNavigationBarButtonTapped(_ sender: Any) {
        listener?.todoListAddButtonTapped()
    }
    
    @IBAction func completeListButtonTapped(_ sender: Any) {
        listener?.completeListButtonTapped()
    }
    
    @IBAction func todoListButtonTapped(_ sender: Any) {
        listener?.todoListButtonTapped()
    }
    private func bind() {
        
        listener?.completedTodos
            .subscribe(onNext: { todos in
                print("완료 된 것")
                print(todos)
            })
            .disposed(by: disposeBag)
        
        listener?.notCompletedTodos
            .subscribe(onNext: { todos in
                print("완료되지 않은것")
                print(todos)
            })
            .disposed(by: disposeBag)
        
    }

}

extension TodoViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
