//
//  SearchPageLocalFilters.swift
//  FinalProject
//
//  Created by Apple on 31.01.25.
//


import Foundation

final class SearchPageLocalFilters {
    static func applyFilters(
        events: [Event],
        searchText: String,
        startDate: Date,
        endDate: Date,
        showFreeEventsOnly: Bool,
        sortOption: SortOption
    ) -> [Event] {
        
        var filteredEvents = events.filter { event in
            if !searchText.isEmpty {
                let lowercased = searchText.lowercased()
                if !(event.name.lowercased().contains(lowercased) ||
                     event.description.lowercased().contains(lowercased) ||
                     (event.location.city?.lowercased().contains(lowercased) ?? false)) {
                    return false
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let eventStartDate = dateFormatter.date(from: event.date.startDate) {
                if !(eventStartDate >= startDate && eventStartDate <= endDate) {
                    return false
                }
            }
            
            if showFreeEventsOnly {
                let price = event.price.discountedPrice ?? event.price.startPrice
                if price != 0 {
                    return false
                }
            }
            
            return true
        }
        
        switch sortOption {
        case .ascending:
            filteredEvents.sort { lhs, rhs in
                let lhsPrice = lhs.price.discountedPrice ?? lhs.price.startPrice
                let rhsPrice = rhs.price.discountedPrice ?? rhs.price.startPrice
                return lhsPrice < rhsPrice
            }
        case .descending:
            filteredEvents.sort { lhs, rhs in
                let lhsPrice = lhs.price.discountedPrice ?? lhs.price.startPrice
                let rhsPrice = rhs.price.discountedPrice ?? rhs.price.startPrice
                return lhsPrice > rhsPrice
            }
        case .none:
            break
        }
        
        return filteredEvents
    }
}
