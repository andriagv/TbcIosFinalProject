

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
        didSet { applyLocalFilters() }
    }
    
    @Published var selectedCategory: EventType? = nil {
        didSet {
            fetchEvents()
        }
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
    
    @Published var hasMoreData: Bool = true
    private let pageSize: UInt = 8
    private var lastChildKey: String? = nil
    
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
    
    // MARK: - Main Fetch
    func fetchEvents() {
        guard !isLoading else {
            return
        }
        isLoading = true
        
        if let category = selectedCategory {
            fetchByCategory(category)
        } else {
            fetchFirstPage()
        }
    }
    
    // MARK: - Page 1 (Unfiltered)
    private func fetchFirstPage() {
        hasMoreData = true
        lastChildKey = nil
        events.removeAll()
        filteredEvents.removeAll()
        
        guard let userId = UserDefaultsManager.shared.getUserId() else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let user = try await UserManager().getUser(by: userId)
                let likedEventIds = user.likedEventIds
                
                let query = databaseRef
                    .child("events")
                    .queryOrderedByKey()
                    .queryLimited(toFirst: pageSize)
                
                query.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else { return }
                    defer { self.isLoading = false }
                                        
                    if !snapshot.hasChildren() {
                        self.hasMoreData = false
                        return
                    }
                    
                    var newEvents: [Event] = []
                    var lastKeyTemp: String? = nil
                    
                    for child in snapshot.children {
                        if let snap = child as? DataSnapshot {
                            let keyStr = snap.key
                            lastKeyTemp = keyStr
                            
                            if let dict = snap.value as? [String: Any] {
                                if let eventObj = self.parseEvent(dict: dict) {
                                    var updated = eventObj
                                    updated.isFavorite = likedEventIds.contains(updated.id)
                                    newEvents.append(updated)
                                } else {
                                    print("parseEvent() failed for key=\(keyStr)")
                                }
                            }
                        }
                    }
                    
                    self.events = newEvents
                    self.filteredEvents = newEvents
                    
                    if let lk = lastKeyTemp {
                        self.lastChildKey = lk
                    }
                    
                    if newEvents.count < Int(self.pageSize) {
                        self.hasMoreData = false
                    }
                    
                    self.applyLocalFilters()
                }
            } catch {
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Page 2..N
    func fetchMoreEvents() {
        guard !isLoading, hasMoreData, let lastKey = lastChildKey else {
            return
        }
        isLoading = true
        
        guard let userId = UserDefaultsManager.shared.getUserId() else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let user = try await UserManager().getUser(by: userId)
                let likedEventIds = user.likedEventIds
                
                let query = databaseRef
                    .child("events")
                    .queryOrderedByKey()
                    .queryStarting(atValue: lastKey)
                    .queryLimited(toFirst: self.pageSize + 1)
                
                query.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else { return }
                    defer { self.isLoading = false }
                    
                    if !snapshot.hasChildren() {
                        self.hasMoreData = false
                        return
                    }
                    
                    var newBatch: [Event] = []
                    var lastKeyTemp: String? = nil
                    
                    for child in snapshot.children {
                        if let snap = child as? DataSnapshot {
                            let keyStr = snap.key
                            lastKeyTemp = keyStr
                            
                            if let dict = snap.value as? [String: Any] {
                                if let eventObj = self.parseEvent(dict: dict) {
                                    var updated = eventObj
                                    updated.isFavorite = likedEventIds.contains(updated.id)
                                    newBatch.append(updated)
                                }
                            }
                        }
                    }
                    
                    
                    let uniqueBatch = newBatch.dropFirst()
                    
                    self.events.append(contentsOf: uniqueBatch)
                    
                    if let lk = lastKeyTemp {
                        self.lastChildKey = lk
                    }
                    
                    if uniqueBatch.count < self.pageSize {
                        self.hasMoreData = false
                    }
                    
                    self.applyLocalFilters()
                }
            } catch {
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Fetch By Category
    private func fetchByCategory(_ category: EventType) {
        
        hasMoreData = false
        lastChildKey = nil
        events.removeAll()
        filteredEvents.removeAll()
        
        guard let userId = UserDefaultsManager.shared.getUserId() else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let user = try await UserManager().getUser(by: userId)
                let likedEventIds = user.likedEventIds
                
                databaseRef.child("events")
                    .observeSingleEvent(of: .value) { [weak self] snapshot in
                        guard let self = self else { return }
                        defer { self.isLoading = false }
                        
                        if !snapshot.hasChildren() {
                            return
                        }
                        
                        var newList: [Event] = []
                        
                        for child in snapshot.children {
                            if let snap = child as? DataSnapshot,
                               let dict = snap.value as? [String:Any] {
                                if let eventObj = self.parseEvent(dict: dict) {
                                    if eventObj.type.rawValue == category.rawValue {
                                        var updated = eventObj
                                        updated.isFavorite = likedEventIds.contains(updated.id)
                                        newList.append(updated)
                                    }
                                }
                            }
                        }
                        
                        self.events = newList
                        self.filteredEvents = newList
                        
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
            var filtered = self.events
            
            if !self.searchText.isEmpty {
                let lowercased = self.searchText.lowercased()
                filtered = filtered.filter { event in
                    event.name.lowercased().contains(lowercased) ||
                    event.description.lowercased().contains(lowercased) ||
                    (event.location.city?.lowercased().contains(lowercased) ?? false)
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            filtered = filtered.filter { event in
                guard let eventStartDate = dateFormatter.date(from: event.date.startDate) else {
                    return true
                }
                
                return eventStartDate >= self.startDate && eventStartDate <= self.endDate
            }
            
            switch self.sortOption {
            case .ascending:
                filtered.sort { lhs, rhs in
                    let lhsPrice = lhs.price.discountedPrice ?? lhs.price.startPrice
                    let rhsPrice = rhs.price.discountedPrice ?? rhs.price.startPrice
                    return lhsPrice < rhsPrice
                }
            case .descending:
                filtered.sort { lhs, rhs in
                    let lhsPrice = lhs.price.discountedPrice ?? lhs.price.startPrice
                    let rhsPrice = rhs.price.discountedPrice ?? rhs.price.startPrice
                    return lhsPrice > rhsPrice
                }
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
        
        DispatchQueue.main.async {
            if let idx = self.filteredEvents.firstIndex(where: { $0.id == event.id }) {
                var updated = event
                updated.isFavorite = newFavoriteStatus
                self.filteredEvents[idx] = updated
            }
            if let idx2 = self.events.firstIndex(where: { $0.id == event.id }) {
                self.events[idx2].isFavorite = newFavoriteStatus
            }
        }
    }
    
    // MARK: - Filter Reset
    func clearFilters() {
        print("clearFilters() CALLED")
        searchText = ""
        selectedCategory = nil
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDate = formatter.date(from: "2025-01-01") ?? Date()
        endDate = formatter.date(from: "2026-01-01") ?? Date().addingTimeInterval(3600 * 24 * 365)
        
        sortOption = .none
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

