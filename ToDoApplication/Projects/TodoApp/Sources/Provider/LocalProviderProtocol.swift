//
//  LocalProviderProtocol.swift
//  ToDoApp
//
//  Created by hong on 2023/08/22.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

protocol LocalProviderProtocol {
    func create<T: LocalStorable>(_ type: T) throws
    func read<T: LocalStorable>(_ type: T) throws -> Decodable
    func delete<T: LocalStorable>(_ type: T) throws
}
