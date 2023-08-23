//
//  PlistProvider.swift
//  ToDoApp
//
//  Created by hong on 2023/08/22.
//  Copyright © 2023 co.godo. All rights reserved.
//

import Foundation

public struct PlistProvider<T: LocalStorable> {
    private enum PlistProviderError: LocalizedError {
        case pathNotFound
        case loadDataFailed
        case encodableDataDeosntExist
        case encodableToJsonFailed
        case readDataDeosntExist
        case decodeTypeDeosntExist
        case deocdableToObjectFaield
    }
    
    fileprivate func plistPath(plistName: String = "Info") throws -> String {
        guard let filePath = Bundle.main.path(forResource: plistName, ofType: "plist") else {
            throw PlistProviderError.pathNotFound
        }
        return filePath
    }
    
    fileprivate func loadPlistDatas() throws -> Dictionary<String, Any> {
        do {
            let filePath = try plistPath()
            guard let plistDatas = NSDictionary(contentsOfFile: filePath) as? Dictionary<String, Any> else {
                throw PlistProviderError.loadDataFailed
            }
            return plistDatas
        } catch {
            throw error
        }
    }
}

extension PlistProvider: LocalProviderProtocol {
    
    public func create<T>(_ type: T) throws where T : LocalStorable {
        do {
            let filePath = try plistPath()
            var loadedPlistData = try loadPlistDatas()
            guard let saveData = type.enocodeData else {
                throw PlistProviderError.encodableDataDeosntExist
            }
            guard let encodedData = try? saveData.toJson() else {
                throw PlistProviderError.encodableToJsonFailed
            }
            loadedPlistData[type.identifier] = encodedData
            let plistEncodedData = try PropertyListSerialization.data(fromPropertyList: loadedPlistData, format: .xml, options: 0)
            try plistEncodedData.write(to:  URL(fileURLWithPath: filePath))
        } catch {
            throw error
        }
    }
    
    public func read<T>(_ type: T) throws -> Decodable where T : LocalStorable {
        do {
            let loadedPlistData = try loadPlistDatas()
            guard let selectData = loadedPlistData[type.identifier] as? Data else {
                throw PlistProviderError.readDataDeosntExist
            }
            guard let returnType = type.decodeType else {
                throw PlistProviderError.decodeTypeDeosntExist
            }
            guard let selectDataEncoded = try? selectData.toObject(returnType) else {
                throw PlistProviderError.deocdableToObjectFaield
            }
            return selectDataEncoded
        } catch {
            throw error
        }
    }
    
    public func delete<T>(_ type: T) throws where T : LocalStorable {
        do {
            let filePath = try plistPath()
            var loadedPlistData = try loadPlistDatas()
            loadedPlistData[type.identifier] = nil
            let plistEncodedData = try PropertyListSerialization.data(fromPropertyList: loadedPlistData, format: .xml, options: 0)
            try plistEncodedData.write(to:  URL(fileURLWithPath: filePath))
        } catch {
            throw error
        }
    }
    
}
