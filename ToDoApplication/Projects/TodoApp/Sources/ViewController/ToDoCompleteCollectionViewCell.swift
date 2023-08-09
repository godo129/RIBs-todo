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
    static let identifier = String(describing: ToDoCompleteCollectionViewCell.self)
    var repository: TodoRepositoryProtocol? = nil
    private var todo: Todo? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ todo: Todo, _ repository: TodoRepositoryProtocol) {
        if let imageData = todo.image {
            todoImageView.image = UIImage(data: imageData)
        }
        toDoDateLabel.text = todo.targetTime.yearMonthDateTime
        toDoTitleLabel.text = todo.title
        isFinishSwitchButton.isOn = true
        self.todo = todo
        self.repository = repository
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        guard let todo,
              let repository else {return}
        let newTodo = Todo(title: todo.title, context: todo.context, image: todo.image, targetTime: todo.targetTime, isCompleted: isFinishSwitchButton.isOn)
        dump(repository.updateTodo(from: todo, to: newTodo))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toDoDateLabel.text = ""
        toDoTitleLabel.text = ""
        isFinishSwitchButton.isOn = true
        self.todo = nil
        self.repository = nil
    }
}
