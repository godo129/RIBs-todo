//
//  UserDefaultsProvider.swift
//  ToDoApp
//
//  Created by hong on 2023/08/22.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public struct UserDefaultsProvider<T: LocalStorable> {
    
    private enum UserDefaultsProviderError: LocalizedError {
        case dataDeleteFailed
        case convertToJsonError
        case encodableDataDoesntExist
        case storedDataDeosntExist
        case decodeDataTypeDoesntExist
        case convertToObjectFailed
    }
    
    private let userDefaults = UserDefaults.standard
}

extension UserDefaultsProvider: LocalProviderProtocol {
    
    public func create<T: LocalStorable>(_ type: T) throws {
        guard let data = type.enocodeData else {
            throw UserDefaultsProviderError.encodableDataDoesntExist
        }
        guard let encodedData = try? data.toJson() else {
            throw UserDefaultsProviderError.convertToJsonError
        }
        userDefaults.set(encodedData, forKey: type.identifier)
    }
    
    public func read<T: LocalStorable>(_ type: T) throws -> Decodable {
        guard let storedData = userDefaults.object(forKey: type.identifier) as? Data else {
            throw UserDefaultsProviderError.storedDataDeosntExist
        }
        guard let returnType = type.decodeType else {
            throw UserDefaultsProviderError.decodeDataTypeDoesntExist
        }
        guard let convertedData = try? storedData.toObject(returnType) else {
            throw UserDefaultsProviderError.convertToObjectFailed
        }
        return convertedData
    }
    
    public func delete<T: LocalStorable>(_ type: T) throws {
        userDefaults.set(nil, forKey: type.identifier)
        guard userDefaults.bool(forKey: type.identifier) == false else {
            throw UserDefaultsProviderError.dataDeleteFailed
        }
    }
}
