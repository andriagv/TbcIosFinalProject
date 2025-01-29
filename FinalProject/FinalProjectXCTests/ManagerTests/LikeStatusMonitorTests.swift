//
//  LikeStatusMonitorTests.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import XCTest
@testable import FinalProject

final class LikeStatusMonitorTests: XCTestCase {
    
    var monitor: LikeStatusMonitor?
    
    override func setUp() {
        super.setUp()
        monitor = LikeStatusMonitor.shared
    }
    
    override func tearDown() {
        monitor = nil
        super.tearDown()
    }
    
    func testStatusChanged() {
        guard let monitor = monitor else {
            XCTFail("monitor is nil")
            return
        }
        
        let initialTime = monitor.lastUpdated
        sleep(1)
        monitor.statusChanged()
        XCTAssertNotEqual(monitor.lastUpdated, initialTime, "Timestamp should be updated after status change")
    }
}

