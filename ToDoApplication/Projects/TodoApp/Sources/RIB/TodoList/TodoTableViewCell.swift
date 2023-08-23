//
//  TodoTableViewCell.swift
//  Resource
//
//  Created by hong on 2023/08/01.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var todoTitle: UILabel!
    @IBOutlet weak var todoContext: UILabel!
    @IBOutlet weak var toDoDate: UILabel!
    @IBOutlet weak var todoCompleteSwitch: UISwitch!
    static let identifier = String(describing: TodoTableViewCell.self)
    private var todo: Todo? = nil
    var changedTodo: ((Todo, Todo) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ todo: Todo) {
        if let imageData = todo.image {
            todoImageView.image = UIImage(data: imageData)
        }
        todoTitle.text = todo.title
        todoContext.text = todo.context
        toDoDate.text = todo.targetTime.yearMonthDateTime
        todoCompleteSwitch.isOn = todo.isCompleted
        self.todo = todo
    }
    
    @IBAction func switchButtonChanged(_ sender: Any) {
        guard let todo else {return}
        let newTodo = Todo(title: todo.title, context: todo.context, image: todo.image, targetTime: todo.targetTime, isCompleted: todoCompleteSwitch.isOn)
        changedTodo!(todo, newTodo)
        self.todo = newTodo
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        todoImageView.image = nil
        todoTitle.text = ""
        todoContext.text = ""
        toDoDate.text = ""
        todoCompleteSwitch.isOn = false
        todo = nil
    }
}

