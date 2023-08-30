//
//  ConstraintRelate.swift
//  NiddleKit
//
//  Created by hong on 2023/08/31.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public class ConstraintRelate {
    
    private let constraintAnchor: ConstraintAnchor
    
    internal init(constraintAnchor: ConstraintAnchor) {
        self.constraintAnchor = constraintAnchor
    }
    
    @discardableResult
    internal func constant(_ constant: CGFloat) -> ConstraintRelate {
        self.constraintAnchor.constant += constant
        return self
    }
}
