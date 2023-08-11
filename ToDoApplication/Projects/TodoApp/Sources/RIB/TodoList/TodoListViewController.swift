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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class TodoListViewController: UIViewController, TodoListPresentable, TodoListViewControllable, ViewControllerInitiable {

    weak var listener: TodoListPresentableListener?
    
    @IBOutlet weak var todoTableView: UITableView!
    private let todoRepository: TodoRepositoryProtocol = TodoRepository(todoProvider: TodoProvider.instance)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoRepository.getNotCompletTodoList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell else { return UITableViewCell() }
        let todo = todoRepository.getNotCompletTodoList()[indexPath.row]
        cell.bind(todo, todoRepository)
        return cell
    }
}
