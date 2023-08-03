//
//  UINavigationBar+.swift
//  ToDoApp
//
//  Created by hong on 2023/08/02.
//

import UIKit

extension UINavigationBar {
    func makeTransparent() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    static func makeTransparent() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }
}
