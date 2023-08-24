//
//  UnitTest.swift
//  Manifests
//
//  Created by hong on 2023/08/09.
//

import XCTest

final class UnitTest: XCTestCase {
    
    private let mockAPIProvider: NetworkProvider<MockAPI> = .init()

    func testAPICallSuccess() throws {
        let expectation = XCTestExpectation()

        Task {
            for mock in MockAPI.allCases {
                if mock == .fail {
                    continue
                }
                do {
                    let datas = try await mockAPIProvider.request(mock).toObject([MockModel].self)
                    XCTAssertEqual(datas.count, mock.count)
                } catch {
                    XCTFail()
                }
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAPICallFail() throws {
        let expectation = XCTestExpectation()

        Task {
            do {
                _ = try await mockAPIProvider.request(.fail)
                XCTFail()
            } catch {
                XCTAssert(true)
            }
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 1.0)
    }
}
