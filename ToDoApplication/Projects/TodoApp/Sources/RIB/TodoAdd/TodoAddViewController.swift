//
//  TodoAddViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//


import RIBs
import RxSwift
import UIKit
import Combine

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
    private let disposeBag = DisposeBag()
    private var cancellabels = Set<AnyCancellable>()
    
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
        keyboardWillAppear.receive(on: DispatchQueue.main).sink { [weak self] cgrect in
            if let keyboardSize = cgrect {
                self?.scrollView.contentInset.bottom = keyboardSize.height
            }
        }
        .store(in: &cancellabels)
        
        keyboardWillHide.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.scrollView.contentInset = .zero
        }
        .store(in: &cancellabels)
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
    
    @objc func addButtonTapped() {
        let todo = Todo(title: todoTitleLabel.text ?? "", context: todoContentLabel.text, image: todoImageSelectButton.imageView?.image?.jpegData(compressionQuality: 0.8), targetTime: selectedDate)
        listener?.saveButtonTapped(todo: todo)
    }
}
