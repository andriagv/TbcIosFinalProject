//
//  LikedEventsManager.swift
//  FinalProject
//
//  Created by Apple on 24.01.25.
//


import Foundation
import FirebaseFirestore

final class LikedEventsManager {
    static let shared = LikedEventsManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func addLikedEvent(for userId: String, event: Event) async throws {
        let userRef = db.collection("users").document(userId)
        try await userRef.updateData([
            "likedEventIds": FieldValue.arrayUnion([event.id])
        ])
    }
    
    func removeLikedEvent(for userId: String, event: Event) async throws {
        let userRef = db.collection("users").document(userId)
        try await userRef.updateData([
            "likedEventIds": FieldValue.arrayRemove([event.id])
        ])
    }
    
    func isEventLiked(eventId: String, userId: String) async throws -> Bool {
        let document = try await db.collection("users").document(userId).getDocument()
        guard let data = document.data(),
              let likedEventIds = data["likedEventIds"] as? [String] else {
            return false
        }
        return likedEventIds.contains(eventId)
    }
}