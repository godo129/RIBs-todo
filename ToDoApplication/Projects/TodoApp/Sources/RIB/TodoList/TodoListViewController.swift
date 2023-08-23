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
}

final class TodoListViewController: UIViewController, TodoListPresentable, TodoListViewControllable, ViewControllerInitiable {

    weak var listener: TodoListPresentableListener?
    
    @IBOutlet weak var todoTableView: UITableView!
    private let disposeBag = DisposeBag()
    private var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        listener?.viewDidLoad()
    }
    
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
        return cell
    }
    
    
}
