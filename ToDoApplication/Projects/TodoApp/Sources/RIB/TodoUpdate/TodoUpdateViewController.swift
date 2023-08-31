//
//  TodoUpdateViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/08/25.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import And
import NiddleKit
import Combine

protocol TodoUpdatePresentableListener: AnyObject {
    var imageData: PublishSubject<Data> { get }
    var dateData: PublishSubject<Date> { get }
    var imageFetchErrorOcurred: PublishSubject<String> { get }
    var datePickerErrorOcurred: PublishSubject<String> { get }
    func viewDidLoad()
    func todoDelete(_ todo: Todo)
    func todoUpdate(from: Todo, to: Todo)
    func photoSelectButtonTapped()
    func datePickButtonTapped(selectedDate: Date)
}

final class TodoUpdateViewController: UIViewController, TodoUpdatePresentable, TodoUpdateViewControllable {

    weak var listener: TodoUpdatePresentableListener?
    private lazy var scrollView = UIScrollView().and {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var stackView = UIStackView().and {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 20
    }
    private lazy var todoImageView = UIImageView().and {
        $0.cornerRadius = 10
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        let imageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        $0.addGestureRecognizer(imageViewTapGestureRecognizer)
        $0.isUserInteractionEnabled = true
    }
    private lazy var todoTitleTextField = UITextField().and {
        $0.textColor = .black
        $0.placeholder = "할일 제목을 입력해주세요."
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.cornerRadius = 10
        $0.leftPadding(add: 15)
        $0.rightPadding(add: 15)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var todoContextTextView = UITextView().and {
        $0.textColor = .black
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.cornerRadius = 10
        $0.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var todoTargetDateButton = UIButton().and {
        $0.setTitleColor(.black, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(dateSelectButtonTapped), for: .touchUpInside)
    }
    private lazy var todoTitleLabel = UILabel().and {
        $0.text = "할일 제목"
        $0.textColor = .black
    }
    private lazy var todoContextLabel = UILabel().and {
        $0.text = "할일 내용"
        $0.textColor = .black
    }
    private lazy var todoTimeLabel = UILabel().and {
        $0.text = "시간"
        $0.textColor = .black
    }
    
    private var todo: Todo?
    private let disposeBag = DisposeBag()
    private var selectedDate = Date()
    private var cancellabels = Set<AnyCancellable>()
    
    init(todo: Todo? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.todo = todo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TodoUpdateViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.viewDidLoad()
        bind()
        configure()
    }
}

extension TodoUpdateViewController {
    private func bind() {
        listener?.imageData
            .subscribe(onNext: { [weak self]imageData in
                DispatchQueue.main.async {
                    self?.todoImageView.image = UIImage(data: imageData)
                    self?.todoImageView.roundCornersForAspectFit(radius: 20)
                }
            })
            .disposed(by: disposeBag)
        
        listener?.imageFetchErrorOcurred
            .subscribe(onNext: { [weak self]errorMessage in
                DispatchQueue.main.async {
                    self?.presentAlertController(title: errorMessage, message: nil)
                }
            })
            .disposed(by: disposeBag)
        
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
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [todoImageView, todoTitleLabel, todoTitleTextField, todoContextLabel, todoContextTextView, todoTimeLabel, todoTargetDateButton].forEach {
            stackView.addArrangedSubview($0)
        }
        viewsContentSetting()
        layout()
        todoTitleTextField.delegate = self
        todoContextTextView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "shift.fill"), style: .plain, target: self, action: #selector(updateButtonTapped))
    }
    
    private func viewsContentSetting() {
        guard let todo else {
            todoTargetDateButton.setTitle(selectedDate.yearMonthDateTime, for: .normal)
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.todoImageView.image = UIImage(data: todo.image ?? Data())
            self?.todoImageView.roundCornersForAspectFit(radius: 20)
            self?.todoTitleTextField.text = todo.title
            self?.todoContextTextView.text = todo.context
            self?.selectedDate = todo.targetTime
            self?.todoTargetDateButton.setTitle(self?.selectedDate.yearMonthDateTime, for: .normal)
        }
    }
    
    private func layout() {
        
        scrollView.ndl.makeConstraints { make in
            make.edges.equalTo(view, needSafeAreaLayoutGuide: true)
        }
        stackView.ndl.makeConstraints { make in
            make.edges.equalTo(scrollView).constant(10)
            make.width.equalTo(scrollView).constant(-20)
        }
        todoImageView.ndl.makeConstraints { make in
            make.height.equalTo(200)
        }
        todoTitleTextField.ndl.makeConstraints { make in
            make.height.equalTo(50)
        }
        todoContextTextView.ndl.makeConstraints { make in
            make.height.equalTo(200)
        }
    
    }
    @objc private func imageViewTapped() {
        listener?.photoSelectButtonTapped()
    }
    @objc private func updateButtonTapped() {
        guard let todo else {
            return
        }
        let currentTodo = Todo(
            title: todoTitleTextField.text ?? "",
            context: todoContextTextView.text,
            image: todoImageView.image?.pngData(),
            targetTime: selectedDate,
            isCompleted: todo.isCompleted
        )
        listener?.todoUpdate(from: todo, to: currentTodo)
    }
    
    @objc private func dateSelectButtonTapped() {
        listener?.datePickButtonTapped(selectedDate: selectedDate)
    }
    
}

extension TodoUpdateViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        todoTitleTextField.endEditing(true)
    }
}


