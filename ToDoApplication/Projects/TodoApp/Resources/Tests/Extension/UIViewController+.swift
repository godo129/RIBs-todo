//
//  UIViewController+.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import UIKit

extension UIViewController {
    /// 확인 버튼이 있는 경고창
    func presentAlertController(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
