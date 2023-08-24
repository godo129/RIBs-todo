//
//  LocalTargetType.swift
//  ToDoApp
//
//  Created by hong on 2023/08/22.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public protocol LocalStorable {
    var identifier: String { get }
    var encodeType: Encodable.Type? { get }
    var decodeType: Decodable.Type? { get }
    var enocodeData: Encodable? { get }
}

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
