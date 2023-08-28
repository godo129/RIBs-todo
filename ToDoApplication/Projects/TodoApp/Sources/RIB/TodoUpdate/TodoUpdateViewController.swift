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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "shift.fill"), style: .plain, target: self, action: #selector(updateButtonTapped))
    }
    
    private func viewsContentSetting() {
        guard let todo else {
            todoTargetDateButton.setTitle(selectedDate.yearMonthDateTime, for: .normal)
            return
        }
        todoImageView.image = UIImage(data: todo.image ?? Data())
        todoTitleTextField.text = todo.title
        todoContextTextView.text = todo.context
        selectedDate = todo.targetTime
        todoTargetDateButton.setTitle(selectedDate.yearMonthDateTime, for: .normal)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),

            todoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            todoTitleTextField.heightAnchor.constraint(equalToConstant: 50),
                        
            todoContextTextView.heightAnchor.constraint(equalToConstant: 200),
            
        ])
    
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


