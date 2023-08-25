//
//  UITextField+.swift
//  ToDoApp
//
//  Created by hong on 2023/08/25.
//  Copyright © 2023 co.godo. All rights reserved.
//

import UIKit

extension UITextField {
    func leftPadding(add: CGFloat) {
        let view = UIView(frame: .init(x: 0, y: 0, width: add, height: self.frame.height))
        self.leftView = view
        self.leftViewMode = .always
    }
    func rightPadding(add: CGFloat) {
        let view = UIView(frame: .init(x: 0, y: 0, width: add, height: self.frame.height))
        self.rightView = view
        self.rightViewMode = .always
    }
}
