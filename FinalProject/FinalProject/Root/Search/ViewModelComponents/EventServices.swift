//
//  EventServices.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import Foundation

// MARK: - Enums
enum SortOption: String, CaseIterable {
    case none = "None"
    case ascending = "Low to High"
    case descending = "High to Low"
}

// MARK: - Protocol
protocol EventSortable {
    func sortEvents(_ events: [Event], by option: SortOption) -> [Event]
}

// MARK: - Implementation
final class EventSorter: EventSortable {
    
    // MARK: - Public Methods
    func sortEvents(_ events: [Event], by option: SortOption) -> [Event] {
        switch option {
        case .none:
            return events
        case .ascending:
            return sortByPrice(events, ascending: true)
        case .descending:
            return sortByPrice(events, ascending: false)
        }
    }
    
    // MARK: - Private Methods
    private func sortByPrice(_ events: [Event], ascending: Bool) -> [Event] {
        return events.sorted { first, second in
            let firstPrice = getEffectivePrice(first)
            let secondPrice = getEffectivePrice(second)
            
            return ascending ? firstPrice < secondPrice : firstPrice > secondPrice
        }
    }
    
    private func getEffectivePrice(_ event: Event) -> Double {
        return event.price.discountedPrice ?? event.price.startPrice
    }
}

// MARK: - Sorting Extensions
extension Event {
    func comparePrice(with other: Event) -> ComparisonResult {
        let selfPrice = self.price.discountedPrice ?? self.price.startPrice
        let otherPrice = other.price.discountedPrice ?? other.price.startPrice
        
        if selfPrice < otherPrice {
            return .orderedAscending
        } else if selfPrice > otherPrice {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
}
