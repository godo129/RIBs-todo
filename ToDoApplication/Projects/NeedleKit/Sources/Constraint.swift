//
//  Constraint.swift
//  NiddleKit
//
//  Created by hong on 2023/08/31.
//  Copyright © 2023 co.godo. All rights reserved.
//

import UIKit

public class Constraint {
    
    internal let type: AnchorAttribute
    internal let from: UIView
    internal let to: UIView
    internal let constant: CGFloat
    internal let needSafeAreaLayout: Bool
    
    internal init(type: AnchorAttribute, from: UIView, to: UIView, constant: CGFloat, needSafeAreaLayout: Bool) {
        self.type = type
        self.from = from
        self.to = to
        self.constant = constant
        self.needSafeAreaLayout = needSafeAreaLayout
    }

}
