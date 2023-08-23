//
//  URLRequest+.swift
//  ToDoApp
//
//  Created by hong on 2023/08/23.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

extension URLRequest {
    var description: String {
        var descriptionString = ""
        descriptionString += "URL: \(self.url?.absoluteString ?? "nil")\n"
        descriptionString += "HTTPMethod: \(self.httpMethod ?? "nil")\n"
        descriptionString += "Headers: \(self.allHTTPHeaderFields ?? [:])\n"
        descriptionString += "HTTP Body: \(String(data: self.httpBody ?? Data(), encoding: .utf8) ?? "nil")\n"
        return descriptionString
    }
}
