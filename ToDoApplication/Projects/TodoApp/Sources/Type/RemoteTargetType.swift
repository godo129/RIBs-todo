//
//  RemoteTargetType.swift
//  ToDoApp
//
//  Created by hong on 2023/08/23.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public enum HTTPMethod: String  {
    case get = "GET"
    case post = "POST"
}

public protocol RemoteTargetType {
    var base: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var data: Data? { get }
    var headers: [String: String]? { get }
    var paramters: [String: String]? { get }
    func asRequest() -> URLRequest?
}

extension RemoteTargetType {
    func asRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: base + path) else {
            return nil
        }
        if let queries = paramters {
            let queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = data
        print("-------")
        print("🚀🚀🚀🚀")
        print("Request")
        print(urlRequest.description)
        print("Query Paramters: \(urlComponents.queryItems ?? [])")
        return urlRequest
    }
}
