//
//  ToDoCompleteCollectionViewCell.swift
//  Resource
//
//  Created by hong on 2023/08/01.
//

import UIKit

final class ToDoCompleteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var toDoDateLabel: UILabel!
    @IBOutlet weak var toDoTitleLabel: UILabel!
    @IBOutlet weak var isFinishSwitchButton: UISwitch!
    @IBOutlet weak var todoStackView: UIStackView!

    static let identifier = String(describing: ToDoCompleteCollectionViewCell.self)
    private var todo: Todo? = nil
    var todoChanged: ((Todo, Todo) -> Void)? = nil
    var todoTapped: ((Todo) -> Void)? = nil
    var deleteTodo: ((Todo) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        todoStackViewConfigure()
    }
    
    private func todoStackViewConfigure() {
        let todoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(todoStackViewTapped))
        todoStackView.addGestureRecognizer(todoTapRecognizer)
    }
    
    @objc private func todoStackViewTapped() {
        guard let todoTapped,
              let todo else {
            return
        }
        todoTapped(todo)
    }

    func bind(_ todo: Todo) {
        if let imageData = todo.image {
            todoImageView.image = UIImage(data: imageData)
        }
        toDoDateLabel.text = todo.targetTime.yearMonthDateTime
        toDoTitleLabel.text = todo.title
        isFinishSwitchButton.isOn = true
        self.todo = todo
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        guard let todo else {return}
        let newTodo = Todo(title: todo.title, context: todo.context, image: todo.image, targetTime: todo.targetTime, isCompleted: isFinishSwitchButton.isOn)
        todoChanged!(todo, newTodo)
        self.todo = newTodo
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let deleteTodo,
              let todo else {
            return
        }
        deleteTodo(todo)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        toDoDateLabel.text = ""
        toDoTitleLabel.text = ""
        isFinishSwitchButton.isOn = true
        self.todo = nil
    }
}
