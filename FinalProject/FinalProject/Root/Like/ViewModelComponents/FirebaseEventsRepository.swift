//
//  FirebaseEventsRepository.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import Foundation
import Firebase
import FirebaseFirestore

// MARK: - Repository Protocol
protocol EventsRepository {
    func observeLikedEventIds(userId: String, completion: @escaping ([String]) -> Void) -> ListenerRegistration?
    func fetchEvents(with ids: [String]) async throws -> [Event]
}

// MARK: - Repository Implementation
final class FirebaseEventsRepository: EventsRepository {
    private let database: DatabaseReference
    private let firestore: Firestore
    
    init(database: DatabaseReference = Database.database().reference(),
         firestore: Firestore = .firestore()) {
        self.database = database
        self.firestore = firestore
    }
    
    func observeLikedEventIds(userId: String, completion: @escaping ([String]) -> Void) -> ListenerRegistration? {
        let userRef = firestore.collection("users").document(userId)
        return userRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot,
                  let data = document.data() else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let likedEventIds = data["likedEventIds"] as? [String] ?? []
            completion(likedEventIds)
        }
    }
    
    func fetchEvents(with ids: [String]) async throws -> [Event] {
        guard !ids.isEmpty else { return [] }
        
        return try await withCheckedThrowingContinuation { continuation in
            database.child("events").observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [[String: Any]] else {
                    continuation.resume(throwing: NetworkError.parsingError)
                    return
                }
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: value)
                    let allEvents = try JSONDecoder().decode([Event].self, from: data)
                    let likedEvents = allEvents.filter { ids.contains($0.id) }
                    continuation.resume(returning: likedEvents)
                } catch {
                    continuation.resume(throwing: NetworkError.parsingError)
                }
            }
        }
    }
}
