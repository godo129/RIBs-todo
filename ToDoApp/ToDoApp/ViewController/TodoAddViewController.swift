//
//  TodoAddViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import UIKit

final class TodoAddViewController: UIViewController, ViewControllerInitiable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateSelectButton: UIButton!
    @IBOutlet weak var todoTitleLabel: UITextField!
    @IBOutlet weak var todoContentLabel: UITextView!
    @IBOutlet weak var todoImageSelectButton: UIButton!
    private var selectedDate = Date()
    private let todoRepository: TodoRepositoryProtocol = TodoRepository(todoProvider: TodoProvider.instance)
    private let imageProvider: ImageProvider = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func todoImageSelectButtonTapped(_ sender: Any) {
        Task {
            do {
                let imageData = try await imageProvider.pickImage(self)
                todoImageSelectButton.setImage(UIImage(data: imageData)?.resize(targetSize: .init(width: 200, height: 200)), for: .normal)
            } catch {
                presentAlertController(title: error.localizedDescription, message: nil)
            }
        }
    }
    
    private func configure() {
        title = "할일 추가"
        dateSelectButton.setTitle(selectedDate.yearMonthDateTime, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewcontroller = segue.destination as? DatePickerViewController else {return}
        viewcontroller.selectedDate = selectedDate
        viewcontroller.date = { [weak self] date in
            guard let self else {return}
            self.selectedDate = date
            self.dateSelectButton.setTitle(self.selectedDate.yearMonthDateTime, for: .normal)
        }
    }
    
}

extension TodoAddViewController {
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 10
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func addButtonTapped() {
        let todo = Todo(title: todoTitleLabel.text ?? "", context: todoContentLabel.text, image: todoImageSelectButton.imageView?.image?.jpegData(compressionQuality: 0.8), targetTime: selectedDate)
        todoRepository.insertTodo(todo)
        dump(todoRepository.getAllTodoList())
        navigationController?.popViewController(animated: true)
    }
}
