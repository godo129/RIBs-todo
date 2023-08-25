//
//  LocalStorable.swift
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
