//
//  MockAPI.swift
//  NetworkProviderTests
//
//  Created by hong on 2023/08/24.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

enum MockAPI: RemoteTargetType, CaseIterable {
    
    case posts
    case commnets
    case albums
    case photos
    case todos
    case users
    case fail
    
    var base: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .commnets:
            return "/comments"
        case .albums:
            return "/albums"
        case .photos:
            return "/photos"
        case .todos:
            return "/todos"
        case .users:
            return "/users"
        case .fail:
            return "fail"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var data: Encodable? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var paramters: [String : String]? {
        return nil
    }
    
    var count: Int {
        switch self {
        case .posts:
            return 100
        case .commnets:
            return 500
        case .albums:
            return 100
        case .photos:
            return 5000
        case .todos:
            return 200
        case .users:
            return 10
        case .fail:
            return 0
        }
    }
    
}
