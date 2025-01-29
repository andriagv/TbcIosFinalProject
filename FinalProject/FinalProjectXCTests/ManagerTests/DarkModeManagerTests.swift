//
//  DarkModeManagerTests.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import XCTest
@testable import FinalProject

final class DarkModeManagerTests: XCTestCase {
    
    var themeManager: ThemeManaging?
    
    override func setUp() {
        super.setUp()
        themeManager = DarkModeManager.shared
    }
    
    override func tearDown() {
        themeManager = nil
        super.tearDown()
    }
    
    func testSaveAndLoadTheme() {
        guard let themeManager = themeManager else {
            XCTFail("themeManager is nil")
            return
        }
        
        themeManager.saveTheme(.dark)
        XCTAssertEqual(themeManager.currentTheme, .dark)

        themeManager.saveTheme(.light)
        XCTAssertEqual(themeManager.currentTheme, .light)
    }
    
    func testApplyTheme() {
        guard let themeManager = themeManager else {
            XCTFail("themeManager is nil")
            return
        }
        
        let window = UIWindow()
        
        themeManager.saveTheme(.dark)
        themeManager.applyTheme(to: window)
        XCTAssertEqual(window.overrideUserInterfaceStyle, .dark)

        themeManager.saveTheme(.light)
        themeManager.applyTheme(to: window)
        XCTAssertEqual(window.overrideUserInterfaceStyle, .light)
    }
}
