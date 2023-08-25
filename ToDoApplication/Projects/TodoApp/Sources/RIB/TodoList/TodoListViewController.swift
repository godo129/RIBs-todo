//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/07/31.
//

import RIBs
import RxSwift
import UIKit

protocol TodoListPresentableListener: AnyObject {
    var fetchedTodos: PublishSubject<[Todo]> { get }
    func todoStatusChagned(from: Todo, to: Todo)
    func viewDidLoad()
    func viewWillAppear()
    func todoCellTouched(_ todo: Todo?)
    func deleteButtonTapped(_ todo: Todo)
}

final class TodoListViewController: UIViewController, TodoListPresentable, TodoListViewControllable, ViewControllerInitiable {

    weak var listener: TodoListPresentableListener?
    
    @IBOutlet weak var todoTableView: UITableView!
    private let disposeBag = DisposeBag()
    private var todos: [Todo] = []
    
    private func configure() {
        title = "할일들"
        UINavigationBar.makeTransparent()
        let todoTableViewCellNib = UINib(nibName: TodoTableViewCell.identifier, bundle: nil)
        todoTableView.register(todoTableViewCellNib, forCellReuseIdentifier: TodoTableViewCell.identifier)
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.reloadData()
    }
    
    private func bind() {
        listener?.fetchedTodos
            .subscribe(onNext: { [weak self] todos in
                self?.todos = todos
                DispatchQueue.main.async {
                    self?.todoTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension TodoListViewController {
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

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell else { return UITableViewCell() }
        let todo = todos[indexPath.row]
        cell.bind(todo)
        cell.changedTodo = { [weak self] before, after in
            self?.listener?.todoStatusChagned(from: before, to: after)
        }
        cell.deleteTodo = { [weak self] todo in
            self?.presentCancellableAlertController(
                title: "정말로 삭제하시겠습니까?",
                message: "복구할 수 없습니다.",
                action: {
                    self?.listener?.deleteButtonTapped(todo)
                })
        }
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
            let todo = todos[indexPath.row]
            listener?.todoCellTouched(todo)
    }
}
