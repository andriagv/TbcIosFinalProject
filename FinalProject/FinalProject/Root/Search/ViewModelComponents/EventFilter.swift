//
//  EventFilter.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import Foundation

// MARK: - Protocol
protocol EventFilterable {
    func filterEvents(_ events: [Event], searchText: String, startDate: Date, endDate: Date, showFreeOnly: Bool) -> [Event]
}

// MARK: - Implementation
final class EventFilter: EventFilterable {
    
    // MARK: - Public Methods
    func filterEvents(_ events: [Event], searchText: String, startDate: Date, endDate: Date, showFreeOnly: Bool) -> [Event] {
        return events.filter { event in
            isMatchingSearchText(event, searchText) &&
            isWithinDateRange(event, startDate: startDate, endDate: endDate) &&
            meetsPriceCriteria(event, showFreeOnly: showFreeOnly)
        }
    }
    
    // MARK: - Private Methods
    private func isMatchingSearchText(_ event: Event, _ searchText: String) -> Bool {
        guard !searchText.isEmpty else { return true }
        
        let lowercasedSearchText = searchText.lowercased()
        
        return event.name.lowercased().contains(lowercasedSearchText) ||
        event.description.lowercased().contains(lowercasedSearchText) ||
        (event.location.city?.lowercased().contains(lowercasedSearchText) ?? false)
    }
    
    private func isWithinDateRange(_ event: Event, startDate: Date, endDate: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let eventStartDate = dateFormatter.date(from: event.date.startDate) else {
            return false
        }
        
        return eventStartDate >= startDate && eventStartDate <= endDate
    }
    
    private func meetsPriceCriteria(_ event: Event, showFreeOnly: Bool) -> Bool {
        guard showFreeOnly else { return true }
        
        let price = event.price.discountedPrice ?? event.price.startPrice
        return price == 0
    }
}

// MARK: - Date Extension
private extension Date {
    func isSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isWithinRange(startDate: Date, endDate: Date) -> Bool {
        return self >= startDate && self <= endDate
    }
}
