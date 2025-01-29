//
//  LikedEventsManagerTests.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import XCTest
@testable import FinalProject
import FirebaseFirestore

final class LikedEventsManagerTests: XCTestCase {
    
    var likedEventsManager: LikedEventsManager?
    
    override func setUp() async throws {
        try await super.setUp()
        likedEventsManager = LikedEventsManager.shared
    }
    
    override func tearDown() async throws {
        likedEventsManager = nil
        try await super.tearDown()
    }
    
    func testAddAndRemoveLikedEvent() async throws {
        guard let likedEventsManager = likedEventsManager else {
            XCTFail("likedEventsManager is nil")
            return
        }
        
        let userId = "testUser123"
        let event = Event(
            id: "1",
            name: "Cemtan saxlshi d",
            type: .tour,
            price: Price(startPrice: 12, discountedPrice: 11),
            date: EventDate(startDate: "2", endDate: "2", durationInDays: 1),
            location: Location(latitude: 22, longitude: 22, address: "dd", city: "dd"),
            seats: Seats(total: 2, available: 3),
            photos: [],
            organizerContact: "df",
            requirements: [],
            tags: [],
            isFavorite: true,
            description: "fd"
        )
        
        try await likedEventsManager.addLikedEvent(for: userId, event: event)
        let isLiked = try await likedEventsManager.isEventLiked(eventId: event.id, userId: userId)
        XCTAssertTrue(isLiked, "Event should be marked as liked")

        try await likedEventsManager.removeLikedEvent(for: userId, event: event)
        let isStillLiked = try await likedEventsManager.isEventLiked(eventId: event.id, userId: userId)
        XCTAssertFalse(isStillLiked, "Event should be removed from liked list")
    }
}
