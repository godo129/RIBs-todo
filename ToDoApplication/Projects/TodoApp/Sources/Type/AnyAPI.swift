//
//  AnyAPI.swift
//  ToDoApp
//
//  Created by hong on 2023/08/23.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public enum AnyAPI: RemoteTargetType {
    
    case `any`(url: String?, httpMethod: HTTPMethod?, data: Encodable?, headers: [String: String]?, paramters: [String: String]?)
    
    public var base: String {
        switch self {
        case let .any(url: url, httpMethod: _, data: _, headers: _, paramters: _):
            return url ?? ""
        }
    }
    
    public var path: String {
        return ""
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case let .any(url: _, httpMethod: method, data: _, headers: _, paramters: _):
            return method ?? .get
        }
    }
    
    public var data: Encodable? {
        switch self {
        case let .any(url: _, httpMethod: _, data: data, headers: _, paramters: _):
            return data
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case let .any(url: _, httpMethod: _, data: _, headers: headers, paramters: _):
            return headers
        }
    }
    
    public var paramters: [String : String]? {
        switch self {
        case let .any(url: _, httpMethod: _, data: _, headers: _, paramters: paramters):
            return paramters
        }
    }
    
}
