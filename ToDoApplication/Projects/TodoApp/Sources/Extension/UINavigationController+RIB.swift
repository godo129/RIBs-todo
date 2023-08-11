//
//  UINavigationController+.swift
//  ToDoApp
//
//  Created by hong on 2023/08/11.
//  Copyright © 2023 co.godo. All rights reserved.
//

import UIKit
import RIBs

extension UINavigationController: ViewControllable {
    public var uiviewController: UIViewController { return self }
    
    public convenience init(root: ViewControllable) {
        self.init(rootViewController: root.uiviewController)
    }
}
