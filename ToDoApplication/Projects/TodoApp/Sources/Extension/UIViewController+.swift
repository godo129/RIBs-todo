//
//  UIViewController+.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import UIKit
import Combine

public extension UIViewController {
    /// 확인 버튼이 있는 경고창
    func presentAlertController(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    /// 취소 가능한 경고창
    func presentCancellableAlertController(title: String?, message: String?, action: @escaping (()->Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let accepttAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            action()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        alertController.addAction(accepttAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension UIViewController {
    var keyboardWillAppear: AnyPublisher<CGRect?, Never> {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification in
                let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                return keyboardFrame
            }
            .eraseToAnyPublisher()
    }
    
    var keyboardWillHide: AnyPublisher<CGRect?, Never> {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in return nil }
            .eraseToAnyPublisher()
    }
}
