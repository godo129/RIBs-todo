//
//  Niddle.swift
//
//  Created by hong on 2023/08/31.
//

import UIKit

extension UIView {

    public var ndl: ConstraintDSL {
       return ConstraintDSL(view: self)
    }
    
    @available(*, deprecated, renamed:"ndl.makeConstraints(_:)")
    public func ndl_makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.ndl.makeConstraints(closure)
    }

}

