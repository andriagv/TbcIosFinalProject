

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
    private let databaseRef = Database.database().reference()
    private let networkMonitor: NetworkMonitorable
    
    // MARK: - Init
    init(networkMonitor: NetworkMonitorable = NetworkMonitor()) {
        self.networkMonitor = networkMonitor
        observeNetworkChanges()
        fetchEvents()
    }
    
    deinit {
        databaseRef.child("events").removeAllObservers()
        print("SearchPageViewModel deinit")
    }
    
    // MARK: - Network Monitoring
    private func observeNetworkChanges() {
        networkMonitor.startMonitoring { [weak self] isConnected in
            DispatchQueue.main.async {
                self?.networkError = !isConnected
                if isConnected, self?.events.isEmpty ?? true {
                    self?.fetchEvents()
                }
            }
        }
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
        
        SearchPageFetchEvents.fetchEvents(
            userId: userId,
            selectedCategory: selectedCategory,
            databaseRef: databaseRef
        ) { [weak self] fetchedEvents in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.events = fetchedEvents
                self?.applyLocalFilters()
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
