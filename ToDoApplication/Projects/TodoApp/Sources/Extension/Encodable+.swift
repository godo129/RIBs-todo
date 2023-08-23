//
//  Encodable+.swift
//  ToDoApp
//
//  Created by hong on 2023/08/22.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

extension Encodable {
    func toJson() throws -> Data {
        do {
            let encodedData = try JSONEncoder().encode(self)
            return encodedData
        } catch {
            print(error)
            throw error
        }
    }
}
