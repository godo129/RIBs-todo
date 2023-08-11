//
//  TodoAddViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//


import RIBs
import RxSwift
import UIKit

protocol TodoAddPresentableListener: AnyObject {
    var imageData: PublishSubject<Data> { get }
    var dateData: PublishSubject<Date> { get }
    var imageFetchErrorOcurred: PublishSubject<String> { get }
    var datePickerErrorOcurred: PublishSubject<String> { get }
    func saveButtonTapped(todo: Todo)
    func photoSelectButtonTapped()
    func datePickButtonTapped(selectedDate: Date)
}

final class TodoAddViewController: UIViewController, TodoAddPresentable, TodoAddViewControllable, ViewControllerInitiable {

    weak var listener: TodoAddPresentableListener?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateSelectButton: UIButton!
    @IBOutlet weak var todoTitleLabel: UITextField!
    @IBOutlet weak var todoContentLabel: UITextView!
    @IBOutlet weak var todoImageSelectButton: UIButton!
    private var selectedDate = Date()
    private let todoRepository: TodoRepositoryProtocol = TodoRepository(todoProvider: TodoProvider.instance)
    private let imageProvider: ImageProvider = .init()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func todoImageSelectButtonTapped(_ sender: Any) {
        listener?.photoSelectButtonTapped()
    }
    
    private func bind() {
        listener?.imageData
            .subscribe(onNext: { [weak self] imageData in
                DispatchQueue.main.async {
                    self?.todoImageSelectButton.setImage(UIImage(data: imageData)?.resize(targetSize: .init(width: 200, height: 200)), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        listener?.imageFetchErrorOcurred
            .subscribe(onNext: { [weak self] errorMessage in
                DispatchQueue.main.async {
                    self?.presentAlertController(title: errorMessage, message: nil)
                }
            })
            .disposed(by: disposeBag)
        
        listener?.dateData
            .subscribe(onNext: { [weak self] dateData in
                DispatchQueue.main.async {
                    self?.selectedDate = dateData
                    self?.dateSelectButton.setTitle(self?.selectedDate.yearMonthDateTime, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        listener?.datePickerErrorOcurred
            .subscribe(onNext: { [weak self] errorMessage in
                DispatchQueue.main.async {
                    self?.presentAlertController(title: errorMessage, message: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        title = "할일 추가"
        dateSelectButton.setTitle(selectedDate.yearMonthDateTime, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    @IBAction func dateSelectButtonTapped(_ sender: Any) {
        listener?.datePickButtonTapped(selectedDate: selectedDate)
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let viewcontroller = segue.destination as? DatePickerViewController else {return}
//        viewcontroller.selectedDate = selectedDate
//        viewcontroller.date = { [weak self] date in
//            guard let self else {return}
//            self.selectedDate = date
//            self.dateSelectButton.setTitle(self.selectedDate.yearMonthDateTime, for: .normal)
//        }
//    }
    
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
        listener?.saveButtonTapped(todo: todo)
    }
}
