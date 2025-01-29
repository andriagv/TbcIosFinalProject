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
    
    private let eventsRepository: EventsRepository
    private let networkMonitor: NetworkMonitorable
    private let userManager: UserManagerProtocol
    private let userDefaults: UserDefaultsManager
    private var userListener: ListenerRegistration?
    
    init(
        eventsRepository: EventsRepository = FirebaseEventsRepository(),
        networkMonitor: NetworkMonitorable = NetworkMonitor(),
        userManager: UserManagerProtocol = UserManager(),
        userDefaults: UserDefaultsManager = .shared
    ) {
        self.eventsRepository = eventsRepository
        self.networkMonitor = networkMonitor
        self.userManager = userManager
        self.userDefaults = userDefaults
        
        setupNetworkMonitoring()
        setupUserListener()
    }
    
    deinit {
        userListener?.remove()
        networkMonitor.stopMonitoring()
    }
    
    private func setupUserListener() {
        guard let userId = userDefaults.getUserId() else {
            print("Error: User ID is nil")
            return
        }
        
        userListener = eventsRepository.observeLikedEventIds(userId: userId) { [weak self] eventIds in
            Task { [weak self] in
                await self?.fetchLikedEvents(for: eventIds)
            }
        }
    }
    
    private func fetchLikedEvents(for eventIds: [String]) async {
        guard !eventIds.isEmpty else {
            self.likedEvents = []
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let events = try await eventsRepository.fetchEvents(with: eventIds)
            self.likedEvents = events
        } catch {
            print("Error fetching liked events: \(error)")
        }
    }
    
    func unlikeEvent(_ event: Event) async throws {
        guard let userId = userDefaults.getUserId() else {
            throw NetworkError.unauthorized
        }
        try await LikedEventsManager.shared.removeLikedEvent(for: userId, event: event)
        self.likedEvents.removeAll { $0.id == event.id }
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.startMonitoring { [weak self] isAvailable in
            Task { @MainActor in
                self?.networkError = !isAvailable
                if isAvailable && self?.likedEvents.isEmpty ?? true {
                    self?.setupUserListener()
                }
            }
        }
    }
}
