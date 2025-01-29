//
//  UserManagerTests.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import XCTest
@testable import FinalProject
import FirebaseFirestore

final class UserManagerTests: XCTestCase {
    
    var userManager: UserManagerProtocol?
    
    override func setUp() async throws {
        try await super.setUp()
        userManager = UserManager()
    }
    
    override func tearDown() async throws {
        userManager = nil
        try await super.tearDown()
    }
    
    func testSaveAndRetrieveUser() async throws {
        guard let userManager = userManager else {
            XCTFail("userManager is nil")
            return
        }
        
        let testUid = "testUser123"
        let testEmail = "testuser@example.com"
        let testFullname = "John Doe"
        let testUsername = "johndoe"
        
        try await userManager.saveUserToFirestore(uid: testUid, email: testEmail, fullname: testFullname, username: testUsername)
        
        let fetchedUser = try await userManager.getUser(by: testUid)
        XCTAssertEqual(fetchedUser.email, testEmail)
        XCTAssertEqual(fetchedUser.fullName, testFullname)
        XCTAssertEqual(fetchedUser.username, testUsername)
    }
    
    func testDeleteUser() async throws {
        guard let userManager = userManager else {
            XCTFail("userManager is nil")
            return
        }
        
        let testUid = "testUser123"
        try await userManager.deleteUser(uid: testUid)
        
        do {
            _ = try await userManager.getUser(by: testUid)
            XCTFail("User should have been deleted")
        } catch {
            XCTAssertTrue(true) 
        }
    }
}
