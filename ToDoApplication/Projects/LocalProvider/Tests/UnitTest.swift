//
//  UnitTest.swift
//  Manifests
//
//  Created by hong on 2023/08/09.
//

import XCTest

final class UnitTest: XCTestCase {

    private var plistProvider: LocalProviderProtocol!
    private var nscacheProvider: LocalProviderProtocol!
    private var userDefatulsProvider: LocalProviderProtocol!
    
    override func setUpWithError() throws {
        plistProvider = PlistProvider<MockLocalTargetType>()
        nscacheProvider = NSCacheProvider<MockLocalTargetType>()
        userDefatulsProvider = UserDefaultsProvider<MockLocalTargetType>()
    }
    
    func testPlistProvider() {
        do {
            let mockData = MockModel()
            try plistProvider.create(MockLocalTargetType.mock(mockData))
            let data = try plistProvider.read(MockLocalTargetType.mock())
            try plistProvider.delete(MockLocalTargetType.mock())
            dump(data)
            XCTAssertEqual(data as! MockModel, mockData, "PlistProvider 테스트 실패")
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testNSCacheProvider() {
        do {
            let mockData = MockModel()
            try nscacheProvider.create(MockLocalTargetType.mock(mockData))
            let data = try nscacheProvider.read(MockLocalTargetType.mock())
            try nscacheProvider.delete(MockLocalTargetType.mock())
            XCTAssertEqual(data as! MockModel, mockData, "NSCacheProvider 테스트 실패")
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUserDefatulsProvider() {
        do {
            let mockData = MockModel()
            try userDefatulsProvider.create(MockLocalTargetType.mock(mockData))
            let data = try userDefatulsProvider.read(MockLocalTargetType.mock())
            try userDefatulsProvider.delete(MockLocalTargetType.mock())
            XCTAssertEqual(data as! MockModel, mockData, "UserDefatulsProvider 테스트 실패")
        } catch {
            XCTFail("\(error)")
        }
    }
}
