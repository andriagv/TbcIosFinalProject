//
//  LikesViewModel.swift
//  FinalProject
//
//  Created by Apple on 24.01.25.
//


import Foundation
import Firebase
import FirebaseFirestore
import Network



@MainActor
final class LikesViewModel: ObservableObject {
    @Published private(set) var likedEvents: [Event] = []
    @Published var isLoading = false
    @Published var networkError: Bool = false
    
    private let databaseRef = Database.database().reference()
    private let userId: String?
    private var userListener: ListenerRegistration?
    private let monitor = NWPathMonitor()
    
    init() {
        userId = UserDefaultsManager.shared.getUserId()
        setupNetworkMonitoring()
        setupUserListener()
    }
    
    deinit {
        userListener?.remove()
        monitor.cancel()
    }
    
    private func setupUserListener() {
        guard let userId else {
            print("Error: User ID is nil")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userId)
        userListener = userRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self else { return }
            guard let document = documentSnapshot, let data = document.data() else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let likedEventIds = data["likedEventIds"] as? [String] ?? []
            self.fetchLikedEvents(for: likedEventIds)
        }
    }
    
    private func fetchLikedEvents(for eventIds: [String]) {
        guard !eventIds.isEmpty else {
            self.likedEvents = []
            return
        }
        
        isLoading = true
        databaseRef.child("events").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self else { return }
            defer { self.isLoading = false }
            
            guard let value = snapshot.value as? [[String: Any]] else {
                print("Error: Invalid snapshot value")
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value)
                let allEvents = try JSONDecoder().decode([Event].self, from: data)
                let likedEvents = allEvents.filter { eventIds.contains($0.id) }
                
                Task { @MainActor in
                    self.likedEvents = likedEvents
                }
            } catch {
                print("Error decoding events: \(error)")
            }
        }
    }
    
    func unlikeEvent(_ event: Event) async throws {
        guard let userId else { return }
        
        try await LikedEventsManager.shared.removeLikedEvent(for: userId, event: event)
        Task { @MainActor in
            self.likedEvents.removeAll { $0.id == event.id }
        }
    }
    
    // MARK: - Network Monitoring
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.networkError = (path.status != .satisfied)
                if !self.networkError && self.likedEvents.isEmpty {
                    self.setupUserListener()
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
}
