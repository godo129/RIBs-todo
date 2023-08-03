//
//  ToDoCompleteCollectionViewCell.swift
//  Resource
//
//  Created by hong on 2023/08/01.
//

import UIKit

final class ToDoCompleteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var toDoDateLabel: UILabel!
    @IBOutlet weak var toDoTitleLabel: UILabel!
    @IBOutlet weak var isFinishSwitchButton: UISwitch!
    static let identifier = String(describing: ToDoCompleteCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func bind(_ todo: Todo) {
        toDoDateLabel.text = todo.targetTime.yearMonthDateTime
        toDoTitleLabel.text = todo.title
        isFinishSwitchButton.isOn = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toDoDateLabel.text = ""
        toDoTitleLabel.text = ""
        isFinishSwitchButton.isOn = true
    }
}
