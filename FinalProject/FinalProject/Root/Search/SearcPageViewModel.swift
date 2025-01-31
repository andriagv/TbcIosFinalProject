

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
    @Published var isLoading = false
    @Published var networkError: Bool = false
    
    @Published var searchText: String = "" {
        didSet { applyLocalFilters() }
    }
    
    @Published var selectedCategory: EventType? = nil {
        didSet {
            fetchEvents()
        }
    }
    
    @Published var showFreeEventsOnly: Bool = false {
        didSet { applyLocalFilters() }
    }
    
    @Published var startDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2025-01-01") ?? Date()
    }() {
        didSet { applyLocalFilters() }
    }
    
    @Published var endDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2026-01-01") ?? Date().addingTimeInterval(3600 * 24 * 365)
    }() {
        didSet { applyLocalFilters() }
    }
    
    @Published var sortOption: SortOption = .none {
        didSet { applyLocalFilters() }
    }
    
    // MARK: - Private
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
    
    // MARK: - Fetch Events
    func fetchEvents() {
        guard !isLoading else { return }
        isLoading = true
        events.removeAll()
        
        guard let userId = UserDefaultsManager.shared.getUserId() else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let user = try await UserManager().getUser(by: userId)
                let likedEventIds = user.likedEventIds
                
                let eventsRef = databaseRef.child("events")
                
                eventsRef.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else { return }
                    defer { self.isLoading = false }
                    
                    if !snapshot.hasChildren() { return }
                    
                    var fetchedEvents: [Event] = []
                    
                    for child in snapshot.children {
                        if let snap = child as? DataSnapshot,
                           let dict = snap.value as? [String: Any],
                           let eventObj = self.parseEvent(dict: dict) {
                            
                            // კატეგორიის ფილტრი
                            if let category = self.selectedCategory {
                                if eventObj.type != category { continue }
                            }
                            
                            var updatedEvent = eventObj
                            updatedEvent.isFavorite = likedEventIds.contains(updatedEvent.id)
                            fetchedEvents.append(updatedEvent)
                        }
                    }
                    
                    self.events = fetchedEvents
                    self.applyLocalFilters()
                }
            } catch {
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Local Filters
    func applyLocalFilters() {
            DispatchQueue.main.async {
                self.events = SearchPageLocalFilters.applyFilters(
                    events: self.events,
                    searchText: self.searchText,
                    startDate: self.startDate,
                    endDate: self.endDate,
                    showFreeEventsOnly: self.showFreeEventsOnly,
                    sortOption: self.sortOption
                )
            }
        }
    
    // MARK: - Filter Reset
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDate = formatter.date(from: "2025-01-01") ?? Date()
        endDate = formatter.date(from: "2026-01-01") ?? Date().addingTimeInterval(3600 * 24 * 365)
        
        sortOption = .none
        showFreeEventsOnly = false
    }
    
    // MARK: - Parsing
    private func parseEvent(dict: [String: Any]) -> Event? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            let decoded = try JSONDecoder().decode(Event.self, from: data)
            return decoded
        } catch {
            return nil
        }
    }
}
