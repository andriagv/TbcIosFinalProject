

//
//  SearchPageViewModel.swift
//  FinalProject
//
//  Created by Apple on 16.01.25.
//


import SwiftUI
import Foundation

final class SearchPageViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var networkError: Bool = false
    @Published var hasMoreData: Bool = true
    
    @Published var searchText: String = "" {
        didSet { applyLocalFilters() }
    }
    
    @MainActor
    @Published var selectedCategory: EventType? = nil {
        didSet {
            hasMoreData = true
            lastChildKey = nil
            events.removeAll()
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
    
    // MARK: - Private Properties
    private let pageSize: UInt = 8
    private var lastChildKey: String? = nil
    
    private let eventRepository: EventFetchable
    private let eventFilter: EventFilterable
    private let eventSorter: EventSortable
    private let networkMonitor: NetworkMonitorable
    
    // MARK: - Initialization
    @MainActor
    init(
        eventRepository: EventFetchable = FirebaseEventRepository(),
        eventFilter: EventFilterable = EventFilter(),
        eventSorter: EventSortable = EventSorter(),
        networkMonitor: NetworkMonitorable = NetworkMonitor()
    ) {
        self.eventRepository = eventRepository
        self.eventFilter = eventFilter
        self.eventSorter = eventSorter
        self.networkMonitor = networkMonitor
        setupNetworkMonitoring()
        fetchEvents()
    }
    
    deinit {
        networkMonitor.stopMonitoring()
    }
    
    // MARK: - Public Methods
    @MainActor
    func fetchEvents() {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                if let category = selectedCategory {
                    hasMoreData = false
                    lastChildKey = nil
                    events.removeAll()
                    
                    let fetchedEvents = try await eventRepository.fetchEventsByCategory(category)
                    self.events = fetchedEvents
                    self.isLoading = false
                    
                } else {
                    let fetchedEvents = try await eventRepository.fetchEvents(
                        pageSize: pageSize,
                        lastKey: lastChildKey
                    )
                    
                    if self.lastChildKey == nil {
                        self.events = fetchedEvents
                    } else {
                        self.events.append(contentsOf: fetchedEvents)
                    }
                    
                    if let lastEvent = fetchedEvents.last {
                        self.lastChildKey = lastEvent.id
                    }
                    
                    self.hasMoreData = fetchedEvents.count >= Int(self.pageSize)
                    self.isLoading = false
                }
            } catch {
                self.isLoading = false
                print("Error fetching events: \(error)")
            }
        }
    }
    
    @MainActor
    func fetchMoreEvents() {
        guard !isLoading,
              hasMoreData,
              lastChildKey != nil,
              selectedCategory == nil
        else { return }
        
        fetchEvents()
    }
    
    @MainActor
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
    
    // MARK: - Private Methods
    @MainActor
    private func setupNetworkMonitoring() {
        networkMonitor.startMonitoring { [weak self] isAvailable in
            guard let self = self else { return }
            self.networkError = !isAvailable
            if isAvailable && self.events.isEmpty {
                self.fetchEvents()
            }
        }
    }
    
    private func applyLocalFilters() {
        let filteredEvents = eventFilter.filterEvents(
            events,
            searchText: searchText,
            startDate: startDate,
            endDate: endDate,
            showFreeOnly: showFreeEventsOnly
        )
        
        events = eventSorter.sortEvents(filteredEvents, by: sortOption)
    }
    
    @MainActor
    private func updateState(events newEvents: [Event], isPagination: Bool = false) {
        if isPagination {
            self.events.append(contentsOf: newEvents)
        } else {
            self.events = newEvents
        }
        
        self.hasMoreData = newEvents.count >= Int(self.pageSize)
        if let lastEvent = newEvents.last {
            self.lastChildKey = lastEvent.id
        }
        
        self.isLoading = false
        self.applyLocalFilters()
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        print("SearchPageViewModel Error: \(error.localizedDescription)")
    }
}
