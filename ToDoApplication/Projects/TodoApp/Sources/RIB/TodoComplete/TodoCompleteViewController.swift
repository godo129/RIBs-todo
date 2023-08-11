//
//  TodoCompleteViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/08/01.
//

import RIBs
import RxSwift
import UIKit

protocol TodoCompletePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class TodoCompleteViewController: UIViewController, TodoCompletePresentable, TodoCompleteViewControllable, ViewControllerInitiable {

    weak var listener: TodoCompletePresentableListener?

    @IBOutlet weak var todoCompletCollectionView: UICollectionView!
    private let todoRepository: TodoRepositoryProtocol = TodoRepository(todoProvider: TodoProvider.instance)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    private func configure() {
        title = "완료현황 보기"
        UINavigationBar.makeTransparent()
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        todoCompletCollectionView.collectionViewLayout = flowLayout
        todoCompletCollectionView.register(UINib(nibName: ToDoCompleteCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ToDoCompleteCollectionViewCell.identifier)
        todoCompletCollectionView.delegate = self
        todoCompletCollectionView.dataSource = self


    }

}

extension TodoCompleteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        todoRepository.getCompletTodoList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoCompleteCollectionViewCell.identifier, for: indexPath) as? ToDoCompleteCollectionViewCell else {return .init()}
        let todo = todoRepository.getCompletTodoList()[indexPath.row]
        cell.bind(todo, todoRepository)
        return cell
    }
    
}

extension UIScreen {
    var physicalSize:CGSize {
        return CGSize(width: bounds.width*scale, height: bounds.height*scale)
    }
}
