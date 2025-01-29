//
//  NetworkMonitorTests.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import XCTest
@testable import FinalProject

final class NetworkMonitorTests: XCTestCase {
    
    var networkMonitor: NetworkMonitor?
    
    override func setUp() {
        super.setUp()
        networkMonitor = NetworkMonitor()
    }
    
    override func tearDown() {
        networkMonitor = nil
        super.tearDown()
    }
    
    func testNetworkMonitor_StartAndStop() {
        guard let networkMonitor = networkMonitor else {
            XCTFail("networkMonitor is nil")
            return
        }

        let expectation = self.expectation(description: "Network monitor starts and stops")

        networkMonitor.startMonitoring { isAvailable in
            XCTAssertNotNil(isAvailable, "Network monitor should detect network status")
            networkMonitor.stopMonitoring()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNetworkStatusCheck() {
        guard let networkMonitor = networkMonitor else {
            XCTFail("networkMonitor is nil")
            return
        }
        
        let isAvailable = networkMonitor.isNetworkAvailable
        XCTAssertNotNil(isAvailable, "Network status check should return a boolean")
    }
}

