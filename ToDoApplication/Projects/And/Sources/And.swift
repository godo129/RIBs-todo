//
//  And.swift
//  ToDoApp
//
//  Created by hong on 2023/08/25.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public protocol And {}

extension And where Self: AnyObject {
    @inlinable
    public func and(_ adjust: ((Self) throws -> Void)) rethrows -> Self {
        try adjust(self)
        return self
    }
}

extension NSObject: And {}
