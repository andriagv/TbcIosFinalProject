//
//  LikesViewModel.swift
//  FinalProject
//
//  Created by Apple on 24.01.25.
//


import Foundation
import Firebase
import FirebaseFirestore

@MainActor
final class LikesViewModel: ObservableObject {
    @Published private(set) var likedEvents: [Event] = []
    @Published var isLoading = false
    private let databaseRef = Database.database().reference()
    private let userId: String?
    private var userListener: ListenerRegistration?
    
    init() {
        userId = UserDefaultsManager.shared.getUserId()
        setupUserListener()
    }
    
    deinit {
        userListener?.remove()
    }
    
    private func setupUserListener() {
        guard let userId else {
            print("havent user ID")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userId)
        userListener = userRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let document = documentSnapshot,
                  let data = document.data() else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let likedEventIds = data["likedEventIds"] as? [String] ?? []
            self?.fetchLikedEvents(for: likedEventIds)
        }
    }
    
    private func fetchLikedEvents(for eventIds: [String]) {
        guard !eventIds.isEmpty else {
            self.likedEvents = []
            return
        }
        
        isLoading = true
        databaseRef.child("events").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                self?.isLoading = false
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value)
                let allEvents = try JSONDecoder().decode([Event].self, from: data)
                let likedEvents = allEvents.filter { eventIds.contains($0.id) }
                
                Task { @MainActor in
                    self?.likedEvents = likedEvents
                    self?.isLoading = false
                }
            } catch {
                print("Error: \(error)")
                self?.isLoading = false
            }
        }
    }
    
    func unlikeEvent(_ event: Event) async throws {
        guard let userId else { return }
        
        try await LikedEventsManager.shared.removeLikedEvent(for: userId, event: event)
        likedEvents.removeAll { $0.id == event.id }
    }
}
