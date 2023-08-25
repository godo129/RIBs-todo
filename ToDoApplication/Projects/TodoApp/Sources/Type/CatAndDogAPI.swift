//
//  CatAndDogAPI.swift
//  ToDoApp
//
//  Created by hong on 2023/08/23.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation
import NetworkProvider

public enum CatAndDogAPI: RemoteTargetType {
    
    case dogImageSearch
    case catImageSearch
    
    public var base: String {
        switch self {
        case .catImageSearch:
            return "https://api.thecatapi.com/v1"
        case .dogImageSearch:
            return "https://api.thedogapi.com/v1"
        }
    }
    
    public var path: String {
        switch self {
        case .dogImageSearch, .catImageSearch:
            return "/images/search"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .dogImageSearch, .catImageSearch:
            return .get
        }
    }
    
    public var data: Encodable? {
        switch self {
        case .dogImageSearch, .catImageSearch:
            return nil
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .dogImageSearch, .catImageSearch:
            return ["content-type": "application/json"]
        }
    }
    
    public var paramters: [String : String]? {
        switch self {
        case .dogImageSearch, .catImageSearch:
            return nil
        }
    }
    
}
