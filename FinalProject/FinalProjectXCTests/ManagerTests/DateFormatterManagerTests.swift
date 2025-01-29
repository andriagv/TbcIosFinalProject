//
//  DateFormatterManagerTests.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import XCTest
@testable import FinalProject

final class DateFormatterManagerTests: XCTestCase {
    
    var dateFormatterManager: DateFormatterManager?
    
    override func setUp() {
        super.setUp()
        dateFormatterManager = DateFormatterManager.shared
    }
    
    override func tearDown() {
        dateFormatterManager = nil
        super.tearDown()
    }
    
    func testFormatDate() {
        guard let dateFormatterManager = dateFormatterManager else {
            XCTFail("dateFormatterManager is nil")
            return
        }
        
        let inputDate = "2025-01-29"
        let expectedOutput = "01-29"
        
        let formattedDate = dateFormatterManager.formatDate(inputDate)
        XCTAssertEqual(formattedDate, expectedOutput, "Date format conversion failed")
    }
    
    func testInvalidDateReturnsSameString() {
        guard let dateFormatterManager = dateFormatterManager else {
            XCTFail("dateFormatterManager is nil")
            return
        }
        
        let invalidDate = "invalid-date"
        let result = dateFormatterManager.formatDate(invalidDate)
        XCTAssertEqual(result, invalidDate, "Invalid date should return the same input")
    }
}
