//
//  LocalTargetType.swift
//  ToDoApp
//
//  Created by hong on 2023/08/24.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public enum LocalTargetType: LocalStorable {

    case todo(_ todo: Todo? = nil)
    
    public var identifier: String {
        switch self {
        case .todo:
            return "Todo"
        }
    }
    
    public var encodeType: Encodable.Type? {
        switch self{
        case .todo:
            return Todo.self
        }
    }
    
    public var decodeType: Decodable.Type? {
        switch self {
        case .todo:
            return Todo.self
        }
    }
    
    public var enocodeData: Encodable? {
        switch self {
        case let .todo(todo):
            return todo
        }
    }
}
