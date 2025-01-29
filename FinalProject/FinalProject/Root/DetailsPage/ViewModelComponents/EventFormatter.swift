//
//  EventFormatter.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import Foundation

protocol EventFormattable {
    func formatDateRange(startDate: String, endDate: String?) -> String
    func formatLocation(city: String?, address: String?) -> String
    func formatDuration(days: Int?) -> String
}

final class EventFormatter: EventFormattable {
    func formatDateRange(startDate: String, endDate: String?) -> String {
        guard let endDate = endDate else {
            return startDate
        }
        return "\(startDate) \(endDate)"
    }
    
    func formatLocation(city: String?, address: String?) -> String {
        guard let city = city else {
            return address ?? "Unknown location"
        }
        return "\(city), \(address ?? "")"
    }
    
    func formatDuration(days: Int?) -> String {
        guard let days = days else { return "0 days" }
        return "\(days) " + (days == 1 ? "day" : "days")
    }
}
