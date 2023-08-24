//
//  MockLocalTargetType.swift
//  FeaturesTests
//
//  Created by hong on 2023/08/24.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation
import LocalProvider

enum MockLocalTargetType: LocalStorable {
    
    case mock(_ mock: MockModel? = nil)
    
    var identifier: String {
        "mock"
    }
    
    var encodeType: Encodable.Type? {
        MockModel.self
    }
    var decodeType: Decodable.Type? {
        MockModel.self
    }
    
    var enocodeData: Encodable? {
        switch self {
        case let .mock(mockModel):
            return mockModel
        }
    }
}
