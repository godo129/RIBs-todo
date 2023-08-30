//
//  ConstraintDSL.swift
//  NiddleKit
//
//  Created by hong on 2023/08/31.
//  Copyright © 2023 co.godo. All rights reserved.
//

import UIKit

public struct ConstraintDSL {
    
    private let view: UIView

    internal init(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view = view
    }
    
    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        return ConstraintMaker.makeConstraint(view: self.view, closure: closure)
    }
}
