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
    var randomImageData: PublishSubject<[Data]> { get }
    func viewDidLoad()
    func viewWillAppear()
    func completeListButtonTapped()
    func todoListButtonTapped()
    func todoListAddButtonTapped()
}

final class TodoViewController: UIViewController, TodoPresentable, TodoViewControllable, ViewControllerInitiable {

    @IBOutlet weak var mainPageImageView: UIImageView!
    @IBOutlet weak var todoListView: UIStackView!
    @IBOutlet weak var todoCompletListView: UIStackView!
    @IBOutlet weak var todoListViewLabel: UILabel!
    @IBOutlet weak var todoCompleteListViewLabel: UILabel!
    weak var listener: TodoPresentableListener?
    private let disposeBag = DisposeBag()
        
    private func configure() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(todoAddNavigationBarButtonTapped))
        navigationItem.hidesBackButton = true
        todoListView.isUserInteractionEnabled = true
        let todoListViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(todoListViewTapped))
        todoListView.addGestureRecognizer(todoListViewTapRecognizer)
        let todoCompleteListViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(todoCompleListViewTapped))
        todoCompletListView.addGestureRecognizer(todoCompleteListViewTapRecognizer)
    }
    
    @objc func todoListViewTapped() {
        listener?.todoListButtonTapped()
    }
    
    @objc func todoCompleListViewTapped() {
        listener?.completeListButtonTapped()
    }
    
    @objc func todoAddNavigationBarButtonTapped(_ sender: Any) {
        listener?.todoListAddButtonTapped()
    }
    
    private func bind() {
        
        listener?.completedTodos
            .subscribe(onNext: { [weak self] todos in
                DispatchQueue.main.async {
                    self?.todoCompleteListViewLabel.text = "완료 할일 목록 \(todos.count) 개"
                }
            })
            .disposed(by: disposeBag)
        
        listener?.notCompletedTodos
            .subscribe(onNext: { [weak self] todos in
                DispatchQueue.main.async {
                    self?.todoListViewLabel.text = "남은 할일 목록 \(todos.count) 개"
                }
            })
            .disposed(by: disposeBag)
        
        listener?.randomImageData
            .subscribe(
                onNext: { [weak self] imageDatas in
                    DispatchQueue.main.async {
                        self?.mainPageImageView.image = UIImage(data: imageDatas[0])
                        self?.mainPageImageView.roundCornersForAspectFit(radius: 30)
                    }
                },
                onError: { [weak self] error in
                    self?.presentAlertController(title: "\(error)", message: nil)
                })
            .disposed(by: disposeBag)
        
    }

}

extension TodoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        listener?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener?.viewWillAppear()
    }
}

extension TodoViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
