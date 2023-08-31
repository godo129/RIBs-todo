//
//  LocalTargetType.swift
//  ToDoApp
//
//  Created by hong on 2023/08/24.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation
import LocalProvider

public enum LocalTargetType: LocalStorable {

    case todo(_ todo: Todo? = nil)
    case catImage(_ imageDatas: [Data]? = nil)
    case dogImage(_ IamgeDatas: [Data]? = nil)
    
    public var identifier: String {
        switch self {
        case .todo:
            return "Todo"
        case .catImage:
            return "catImage"
        case .dogImage:
            return "dogImage"
        }
    }
    
    public var encodeType: Encodable.Type? {
        switch self{
        case .todo:
            return nil
        case .catImage, .dogImage:
            return nil
        }
    }
    
    public var decodeType: Decodable.Type? {
        switch self {
        case .todo:
            return Todo.self
        case .catImage, .dogImage:
            return [Data].self
        }
    }
    
    public var enocodeData: Encodable? {
        switch self {
        case let .todo(todo):
            return todo
        case let .catImage(image), let .dogImage(image):
            return image
        }
    }
}
