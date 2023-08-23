//
//  NSCacheProvider.swift
//  ToDoApp
//
//  Created by hong on 2023/08/22.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public final class NSCacheProvider<T: LocalStorable> {
    fileprivate enum NSCacheProviderError: LocalizedError {
        case encodableDataDeosntExist
        case encodableToJsonFailed
        case savedDataDeosntExist
        case decodeTypeDeosntExist
        case decodableToObjectFailed
        case dataDeleteFailed
    }
    fileprivate var caches = NSCache<NSString, NSChacheData>()
    
    init() {
        caches.totalCostLimit = 5
    }
}

extension NSCacheProvider: LocalProviderProtocol {
    
    public func create<T>(_ type: T) throws where T : LocalStorable {
        guard let encodableData = type.enocodeData else {
            throw NSCacheProviderError.encodableDataDeosntExist
        }
        guard let encodedData = try? encodableData.toJson() else {
            throw NSCacheProviderError.encodableToJsonFailed
        }
        let nschacheData = NSChacheData(data: encodedData)
        caches.setObject(nschacheData, forKey: type.identifier as NSString)
    }
    
    public func read<T>(_ type: T) throws -> Decodable where T : LocalStorable {
        guard let savedData = caches.object(forKey: type.identifier as NSString) else {
            throw NSCacheProviderError.savedDataDeosntExist
        }
        guard let returnType = type.decodeType else {
            throw NSCacheProviderError.decodeTypeDeosntExist
        }
        guard let decodedData = try? savedData.data.toObject(returnType) else {
            throw NSCacheProviderError.decodableToObjectFailed
        }
        return decodedData
    }
    
    public func delete<T>(_ type: T) throws where T : LocalStorable {
        caches.removeObject(forKey: type.identifier as NSString)
        guard caches.object(forKey: type.identifier as NSString) == nil else {
            throw NSCacheProviderError.dataDeleteFailed
        }
    }
    
}
