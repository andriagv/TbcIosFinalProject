

//
//  SearchPageViewModel.swift
//  FinalProject
//
//  Created by Apple on 16.01.25.
//

import Foundation
import SwiftUI


enum SortOption: String, CaseIterable {
    case none = "None"
    case ascending = "Price: Low to High"
    case descending = "Price: High to Low"
}

final class SearchPageViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var searchText: String = "" {
        didSet {
            applyFilters()
        }
    }
    
    @Published private(set) var events: [Event] = []
    
    @Published var filteredEvents: [Event] = []
    
    // MARK: - ფილტრისთვის საჭირო პარამეტრები
    
    @Published var selectedCategory: EventType? = nil {
        didSet {
            applyFilters()
        }
    }
    
    @Published var startDate: Date = Date() {
        didSet {
            applyFilters()
        }
    }
    
    @Published var endDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date() {
        didSet {
            applyFilters()
        }
    }
    
    @Published var sortOption: SortOption = .none {
        didSet {
            applyFilters()
        }
    }
    
    // MARK: - Init
    
    init() {
        loadEvents()
    }
    
    // MARK: - Public Methods
    
    func loadEvents() {
        guard let url = Bundle.main.url(forResource: "mockEvents", withExtension: "json") else {
            print("mockEvents.json ფაილი ვერ მოიძებნა.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let container = try JSONDecoder().decode(EventsContainer.self, from: data)
            events = container.events
            applyFilters()
        } catch {
            print("JSON დეკოდირებაში მოხდა შეცდომა: \(error)")
        }
    }
    
    func applyFilters() {
        var newFilteredEvents = events
        
        if !searchText.isEmpty {
            let lowercasedSearch = searchText.lowercased()
            newFilteredEvents = newFilteredEvents.filter { event in
                event.name.lowercased().contains(lowercasedSearch)
                || event.description.lowercased().contains(lowercasedSearch)
                || (event.location.city?.lowercased().contains(lowercasedSearch) ?? false)
            }
        }
        
        if let category = selectedCategory {
            newFilteredEvents = newFilteredEvents.filter {
                $0.type == category
            }
        }
        
        filteredEvents = newFilteredEvents
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        startDate = Date()
        endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        sortOption = .none
        
        applyFilters()
    }
    
    func fetchAndFilterEvents() {
        applyFilters()
    }
}
