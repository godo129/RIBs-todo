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
    var fetchedTodos: PublishSubject<[Todo]> { get }
    func todoStatusChagned(from: Todo, to: Todo)
    func viewDidLoad()

}

final class TodoCompleteViewController: UIViewController, TodoCompletePresentable, TodoCompleteViewControllable, ViewControllerInitiable {

    weak var listener: TodoCompletePresentableListener?

    @IBOutlet weak var todoCompletCollectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private var todos: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        listener?.viewDidLoad()
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
    
    private func bind() {
        listener?.fetchedTodos
            .subscribe(onNext: { [weak self] todos in
                self?.todos = todos
                DispatchQueue.main.async {
                    self?.todoCompletCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }

}

extension TodoCompleteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoCompleteCollectionViewCell.identifier, for: indexPath) as? ToDoCompleteCollectionViewCell else {return .init()}
        let todo = todos[indexPath.row]
        cell.bind(todo)
        cell.todoChanged = { [weak self] before, after in
            self?.listener?.todoStatusChagned(from: before, to: after)
        }
        return cell
    }
    
}

extension UIScreen {
    var physicalSize:CGSize {
        return CGSize(width: bounds.width*scale, height: bounds.height*scale)
    }
}
