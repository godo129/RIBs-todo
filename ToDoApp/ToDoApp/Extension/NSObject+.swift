//
//  NSObject+.swift
//  ToDoApp
//
//  Created by hong on 2023/07/31.
//

import UIKit
import Resource

extension NSObject {
    static func classNameToString() -> String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    func classNameToString() -> String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

protocol ViewControllerInitiable {
    static func viewControllerInstance(name ofStoryBoard: String) -> UIViewController?
    static func viewControllerInstance() -> UIViewController?
}

extension ViewControllerInitiable where Self: UIViewController {
    static func viewControllerInstance(name ofStoryBoard: String) -> UIViewController? {
        return UIStoryboard(name: ofStoryBoard, bundle: nil).instantiateViewController(withIdentifier: classNameToString()) as? Self
    }
    static func viewControllerInstance() -> UIViewController? {
        return UIStoryboard(name: classNameToString(), bundle: nil).instantiateViewController(withIdentifier: classNameToString()) as? Self
    }
}
