//
//  UnitTest.swift
//  Manifests
//
//  Created by hong on 2023/08/09.
//

import XCTest

final class UnitTest: XCTestCase {

    func testAndPropertyInt() {
        var mockObject = MockObject().and {
            $0.propertyInt = 11
        }
        XCTAssertEqual(mockObject.propertyInt, 11)
    }
    
    func testAndPropertyString() {
        var mockObject = MockObject().and {
            $0.propertyString = "accept"
        }
        XCTAssertEqual(mockObject.propertyString, "accept")
    }
    
}

final class MockObject: NSObject {
    var propertyInt = 0
    var propertyString = "test"
}
