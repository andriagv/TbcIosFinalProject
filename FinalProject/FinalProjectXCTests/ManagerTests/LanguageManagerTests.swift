//
//  LanguageManagerTests.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import XCTest
@testable import FinalProject

final class LanguageManagerTests: XCTestCase {
    
    var languageManager: LanguageManaging?
    
    override func setUp() {
        super.setUp()
        languageManager = LanguageManager.shared
    }
    
    override func tearDown() {
        languageManager = nil
        super.tearDown()
    }
    
    func testSetLanguage() {
        guard let languageManager = languageManager else {
            XCTFail("languageManager is nil")
            return
        }
        
        languageManager.setLanguage("ka")
        XCTAssertEqual(languageManager.selectedLanguage, "ka")

        languageManager.setLanguage("en")
        XCTAssertEqual(languageManager.selectedLanguage, "en")
    }
    
    func testLanguageDisplayName() {
        guard let languageManager = languageManager else {
            XCTFail("languageManager is nil")
            return
        }
        
        XCTAssertEqual(languageManager.languageDisplayName(for: "ka"), "Georgian")
        XCTAssertEqual(languageManager.languageDisplayName(for: "en"), "English")
    }
}
