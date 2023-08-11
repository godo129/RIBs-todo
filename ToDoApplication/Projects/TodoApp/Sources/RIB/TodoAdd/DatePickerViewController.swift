//
//  DatePickerViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import UIKit

final class DatePickerViewController: UIViewController, ViewControllerInitiable {

    @IBOutlet weak var datePicker: UIDatePicker!
    var date: ((Date)->Void)?
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
    }
    
    private func setAttributes() {
        datePicker.date = selectedDate
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "kor")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    @objc private func handleDatePicker() {
        guard let date else {return}
        date(datePicker.date)
    }
    
}
