//
//  TodoViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/07/31.
//

import UIKit

final class TodoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(todoAddNavigationBarButtonTapped))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let todoListViewController = segue.destination as? TodoListViewController {
            // DI 
        }
        if let todoCompleteViewController = segue.destination as? TodoCompleteViewController {
            // DI
        }
    }
    
    @objc func todoAddNavigationBarButtonTapped(_ sender: Any) {
        guard let viewController = TodoAddViewController.viewControllerInstance() else {return}
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TodoViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
