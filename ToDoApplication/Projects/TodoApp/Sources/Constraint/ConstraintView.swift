//
//  ConstraintView.swift
//
//  Created by hong on 2023/08/29.
//  Copyright © 2023 co.godo. All rights reserved.
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

public class ConstraintMaker {
    
    public var top: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .top))
    }
    public var bottom: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .bottom))
    }
    public var left: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .left))
    }
    public var right: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .right))
    }
    public var width: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .width))
    }
    public var height: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .heigth))
    }
    public var centerX: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .centerX))
    }
    public var centerY: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .CenterY))
    }
    public var firstBaseLine: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .firstBaseLine))
    }
    public var lastBaseLine: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .lastBaseLine))
    }
    public var leading: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .leading))
    }
    public var trailing: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .trailing))
    }
    
    private var anchors: [ConstraintAnchor] = []
    
    private var view: UIView
    
    internal init(_ view: UIView) {
        self.view = view
    }
    
    internal static func makeConstraint(
        view: UIView,
        closure: (_ make: ConstraintMaker) -> Void
    ) {
        let constraints = prepareConstraints(view, closure: closure)
        for constraint in constraints {
            let nsConstraint: NSLayoutConstraint
            switch constraint.type {
            case.top:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.topAnchor : constraint.to.topAnchor
                nsConstraint = constraint.from.topAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .left:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.leftAnchor : constraint.to.leftAnchor
                nsConstraint = constraint.from.leftAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .right:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.rightAnchor : constraint.to.rightAnchor
                nsConstraint = constraint.from.rightAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .bottom:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.bottomAnchor : constraint.to.bottomAnchor
                nsConstraint = constraint.from.bottomAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .leading:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.leadingAnchor : constraint.to.leadingAnchor
                nsConstraint = constraint.from.leadingAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .trailing:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.trailingAnchor : constraint.to.trailingAnchor
                nsConstraint = constraint.from.trailingAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .lastBaseLine:
                let fromAnchor = constraint.to.lastBaselineAnchor
                nsConstraint = constraint.from.lastBaselineAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .firstBaseLine:
                let fromAnchor = constraint.to.firstBaselineAnchor
                nsConstraint = constraint.from.firstBaselineAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .CenterY:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.centerYAnchor : constraint.to.centerYAnchor
                nsConstraint = constraint.from.centerYAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .centerX:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.centerXAnchor : constraint.to.centerXAnchor
                nsConstraint = constraint.from.centerXAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .heigth:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.heightAnchor : constraint.to.heightAnchor
                nsConstraint = constraint.from.heightAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            case .width:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.widthAnchor : constraint.to.widthAnchor
                nsConstraint = constraint.from.widthAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant)
            }
            nsConstraint.isActive = true
        }
    }
    
    internal static func prepareConstraints(_ view: UIView, closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        let constraintMaker = ConstraintMaker(view)
        closure(constraintMaker)
        var constraints: [Constraint] = []
        for anchor in constraintMaker.anchors {
            if let to = anchor.to {
                let constraint = Constraint(type: anchor.type, from: constraintMaker.view, to: to, constant: anchor.constant, needSafeAreaLayout: anchor.needSafeAreaLayoutGuide)
                constraints.append(constraint)
            }
        }
        return constraints
    }
    
    private func anchorAppend(_ constraintAnchor: ConstraintAnchor) -> ConstraintAnchor {
        self.anchors.append(constraintAnchor)
        return constraintAnchor
    }
}

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


internal enum AnchorAttribute {
    case top
    case bottom
    case left
    case right
    case width
    case heigth
    case centerX
    case CenterY
    case firstBaseLine
    case lastBaseLine
    case leading
    case trailing
}

public class ConstraintAnchor {

    internal let type: AnchorAttribute
    internal var needSafeAreaLayoutGuide: Bool = false
    internal var to: UIView?
    internal var constant: CGFloat = 0.0
    
    init(type: AnchorAttribute) {
        self.type = type
    }

    @discardableResult
    func equalTo(_ view: UIView, needSafeAreaLayoutGuide: Bool = false) -> ConstraintRelate {
        self.needSafeAreaLayoutGuide = needSafeAreaLayoutGuide
        self.to = view
        return ConstraintRelate(constraintAnchor: self)
    }
}

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
