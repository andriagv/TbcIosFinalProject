

//
//  SearchPageViewModel.swift
//  FinalProject
//
//  Created by Apple on 16.01.25.
//

import SwiftUI
import Foundation
import Network
import FirebaseDatabase
import FirebaseFirestore

enum SortOption: String, CaseIterable {
    case none = "None"
    case ascending = "Low to High"
    case descending = "High to Low"
}

final class SearchPageViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var events: [Event] = []
    @Published var filteredEvents: [Event] = []
    @Published var isLoading = false
    @Published var networkError: Bool = false
    
    @Published var searchText: String = "" {
        didSet {
            applyLocalFilters()
        }
    }
    @Published var selectedCategory: EventType? = nil {
        didSet {
            applyLocalFilters()
        }
    }
    @Published var startDate: Date = Date() {
        didSet {
            applyLocalFilters()
        }
    }
    @Published var endDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date() {
        didSet {
            applyLocalFilters()
        }
    }
    @Published var sortOption: SortOption = .none {
        didSet {
            applyLocalFilters()
        }
    }
    
    // MARK: - Private Properties
    private let monitor = NWPathMonitor()
    private let databaseRef = Database.database().reference()
    
    // MARK: - Init
    init() {
        setupNetworkMonitoring()
        fetchEvents()
    }
    
    deinit {
        monitor.cancel()
        databaseRef.child("events").removeAllObservers()
        print("SearchPageViewModel deinit")
    }
    
    // MARK: - Network Monitoring
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.networkError = false
                    if self?.events.isEmpty ?? true {
                        self?.fetchEvents()
                    }
                } else {
                    self?.networkError = true
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    // MARK: - Data Fetching
    func fetchEvents() {
        guard !isLoading else { return }
        isLoading = true
        
        guard let userId = UserDefaultsManager.shared.getUserId() else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let user = try await UserManager().getUser(by: userId)
                let likedEventIds = user.likedEventIds
                
                databaseRef.child("events").observe(.value) { [weak self] snapshot in
                    guard let self = self else { return }
                    
                    defer {
                        self.isLoading = false
                    }
                    
                    guard let value = snapshot.value as? [[String: Any]] else {
                        print("მონაცემები არასწორი ფორმატით მივიღეთ")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: value)
                            let decoder = JSONDecoder()
                            var fetchedEvents = try decoder.decode([Event].self, from: data)
                            
                            fetchedEvents = fetchedEvents.map { event in
                                var updatedEvent = event
                                updatedEvent.isFavorite = likedEventIds.contains(event.id)
                                return updatedEvent
                            }
                            
                            self.events = fetchedEvents
                            self.filteredEvents = fetchedEvents
                            self.saveEventsToCache(events: fetchedEvents)
                            
                        } catch {
                            print("პარსინგის შეცდომა: \(error)")
                        }
                    }
                }
            } catch {
                print("იუზერის ინფორმაციის წამოღების შეცდომა: \(error)")
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Caching
    private func saveEventsToCache(events: [Event]) {
        do {
            let data = try JSONEncoder().encode(events)
            UserDefaults.standard.set(data, forKey: "cached_events")
        } catch {
            print("ქეშირების შეცდომა: \(error)")
        }
    }
    
    private func loadEventsFromCache() -> [Event]? {
        guard let data = UserDefaults.standard.data(forKey: "cached_events") else {
            return nil
        }
        do {
            return try JSONDecoder().decode([Event].self, from: data)
        } catch {
            print("ქეშის წაკითხვის შეცდომა: \(error)")
            return nil
        }
    }
    
    // MARK: - Filtering
    func applyLocalFilters() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            var filtered = self.events
            
            // Category Filter
            if let category = self.selectedCategory {
                filtered = filtered.filter { $0.type == category }
            }
            
            // Search Text Filter
            if !self.searchText.isEmpty {
                let lowercasedSearch = self.searchText.lowercased()
                filtered = filtered.filter { event in
                    event.name.lowercased().contains(lowercasedSearch) ||
                    event.description.lowercased().contains(lowercasedSearch) ||
                    (event.location.city?.lowercased().contains(lowercasedSearch) ?? false)
                }
            }
            
            // Date Range Filter
            filtered = filtered.filter { event in
                if let startDate = ISO8601DateFormatter().date(from: event.date.startDate) {
                    return startDate >= self.startDate && startDate <= self.endDate
                }
                return true
            }
            
            // Sort Option
            switch self.sortOption {
            case .ascending:
                filtered.sort { $0.price.startPrice < $1.price.startPrice }
            case .descending:
                filtered.sort { $0.price.startPrice > $1.price.startPrice }
            case .none:
                break
            }
            self.filteredEvents = filtered
        }
    }
    
    // MARK: - toggleLike
    
    func toggleLike(for event: Event) async throws {
        guard let userId = UserDefaultsManager.shared.getUserId() else { return }
        let newFavoriteStatus = !event.isFavorite
        
        if newFavoriteStatus {
            try await LikedEventsManager.shared.addLikedEvent(for: userId, event: event)
        } else {
            try await LikedEventsManager.shared.removeLikedEvent(for: userId, event: event)
        }
        
        DispatchQueue.main.async { [self] in
            if let index = filteredEvents.firstIndex(where: { $0.id == event.id }) {
                var updatedEvent = event
                updatedEvent.isFavorite = newFavoriteStatus
                filteredEvents[index] = updatedEvent
            }
        }
    }
    
    // MARK: - Filter Reset
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        startDate = Date()
        endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        sortOption = .none
        applyLocalFilters()
    }
}
