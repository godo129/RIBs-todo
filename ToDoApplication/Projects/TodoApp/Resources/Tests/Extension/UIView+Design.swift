//
//  UIView+Design.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            UIColor(cgColor: layer.borderColor ?? UIColor().cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

