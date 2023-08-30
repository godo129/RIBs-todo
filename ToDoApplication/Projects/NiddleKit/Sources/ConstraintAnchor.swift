//
//  ConstraintAnchor.swift
//  NiddleKit
//
//  Created by hong on 2023/08/31.
//  Copyright © 2023 co.godo. All rights reserved.
//

import UIKit

public class ConstraintAnchor {

    internal let type: AnchorAttribute
    internal var needSafeAreaLayoutGuide: Bool = false
    internal var to: UIView?
    internal var constant: CGFloat = 0.0
    
    internal init(type: AnchorAttribute) {
        self.type = type
    }

    @discardableResult
    public func equalTo(_ view: UIView, needSafeAreaLayoutGuide: Bool = false) -> ConstraintRelate {
        self.needSafeAreaLayoutGuide = needSafeAreaLayoutGuide
        self.to = view
        return ConstraintRelate(constraintAnchor: self)
    }
    
    @discardableResult
    public func equalTo(_ constant: CGFloat) -> ConstraintRelate {
        self.constant = constant
        return ConstraintRelate(constraintAnchor: self)
    }
}
