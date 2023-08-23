//
//  Data+.swift
//  ToDoApp
//
//  Created by hong on 2023/08/22.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

extension Data {
    func toObject<T: Decodable>(_ type: T.Type) throws -> T {
        do {
            let docodedData = try JSONDecoder().decode(type, from: self)
            return docodedData
        } catch {
            print(error)
            throw error
        }
    }
}
