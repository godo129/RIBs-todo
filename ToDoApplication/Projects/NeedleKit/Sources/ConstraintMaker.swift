//
//  ConstraintMaker.swift
//  NiddleKit
//
//  Created by hong on 2023/08/31.
//  Copyright © 2023 co.godo. All rights reserved.
//

import UIKit

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
    public var edges: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .edges))
    }
    public var horizontal: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .width))
    }
    public var vertical: ConstraintAnchor {
        return anchorAppend(ConstraintAnchor(type: .vertical))
    }
    
    private var anchors: [ConstraintAnchor] = []
    
    private var view: UIView
    private static let empthyView: UIView = UIView()
    
    internal init(_ view: UIView) {
        self.view = view
    }
    
    internal static func makeConstraint(
        view: UIView,
        closure: (_ make: ConstraintMaker) -> Void
    ) {
        let constraints = prepareConstraints(view, closure: closure)
        for constraint in constraints {
            var nsConstraints: [NSLayoutConstraint] = []
            switch constraint.type {
            case.top:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.topAnchor : constraint.to.topAnchor
                nsConstraints.append(constraint.from.topAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .left:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.leftAnchor : constraint.to.leftAnchor
                nsConstraints.append(constraint.from.leftAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .right:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.rightAnchor : constraint.to.rightAnchor
                nsConstraints.append(constraint.from.rightAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .bottom:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.bottomAnchor : constraint.to.bottomAnchor
                nsConstraints.append(constraint.from.bottomAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .leading:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.leadingAnchor : constraint.to.leadingAnchor
                nsConstraints.append(constraint.from.leadingAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .trailing:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.trailingAnchor : constraint.to.trailingAnchor
                nsConstraints.append(constraint.from.trailingAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .lastBaseLine:
                let fromAnchor = constraint.to.lastBaselineAnchor
                nsConstraints.append(constraint.from.lastBaselineAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .firstBaseLine:
                let fromAnchor = constraint.to.firstBaselineAnchor
                nsConstraints.append(constraint.from.firstBaselineAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .CenterY:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.centerYAnchor : constraint.to.centerYAnchor
                nsConstraints.append(constraint.from.centerYAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .centerX:
                let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.centerXAnchor : constraint.to.centerXAnchor
                nsConstraints.append(constraint.from.centerXAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
            case .heigth:
                if constraint.to == empthyView {
                    nsConstraints.append(constraint.from.heightAnchor.constraint(equalToConstant: constraint.constant))
                } else {
                    let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.heightAnchor : constraint.to.heightAnchor
                    nsConstraints.append(constraint.from.heightAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
                }
            case .width:
                if constraint.to == empthyView {
                    nsConstraints.append(constraint.from.widthAnchor.constraint(equalToConstant: constraint.constant))
                } else {
                    let fromAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.widthAnchor : constraint.to.widthAnchor
                    nsConstraints.append(constraint.from.widthAnchor.constraint(equalTo: fromAnchor, constant: constraint.constant))
                }
            case .edges:
                let fromTopAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.topAnchor : constraint.to.topAnchor
                nsConstraints.append(constraint.from.topAnchor.constraint(equalTo: fromTopAnchor, constant: constraint.constant))
                let fromLeftAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.leftAnchor : constraint.to.leftAnchor
                nsConstraints.append(constraint.from.leftAnchor.constraint(equalTo: fromLeftAnchor, constant: constraint.constant))
                let fromRightAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.rightAnchor : constraint.to.rightAnchor
                nsConstraints.append(constraint.from.rightAnchor.constraint(equalTo: fromRightAnchor, constant: constraint.constant))
                let fromBottomAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.bottomAnchor : constraint.to.bottomAnchor
                nsConstraints.append(constraint.from.bottomAnchor.constraint(equalTo: fromBottomAnchor, constant: constraint.constant))
            case .horizontal:
                let fromLeftAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.leftAnchor : constraint.to.leftAnchor
                nsConstraints.append(constraint.from.leftAnchor.constraint(equalTo: fromLeftAnchor, constant: constraint.constant))
                let fromRightAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.rightAnchor : constraint.to.rightAnchor
                nsConstraints.append(constraint.from.rightAnchor.constraint(equalTo: fromRightAnchor, constant: constraint.constant))
            case .vertical:
                let fromTopAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.topAnchor : constraint.to.topAnchor
                nsConstraints.append(constraint.from.topAnchor.constraint(equalTo: fromTopAnchor, constant: constraint.constant))
                let fromBottomAnchor = constraint.needSafeAreaLayout ? constraint.to.safeAreaLayoutGuide.bottomAnchor : constraint.to.bottomAnchor
                nsConstraints.append(constraint.from.bottomAnchor.constraint(equalTo: fromBottomAnchor, constant: constraint.constant))
            }
            NSLayoutConstraint.activate(nsConstraints)
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
            } else if anchor.type == .width || anchor.type == .heigth {
                let constraint = Constraint(type: anchor.type, from: constraintMaker.view, to: empthyView, constant: anchor.constant, needSafeAreaLayout: anchor.needSafeAreaLayoutGuide)
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
