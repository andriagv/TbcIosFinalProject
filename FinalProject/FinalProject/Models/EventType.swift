//
//  EventType.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation

enum EventType: String, Codable, CaseIterable {
    case camping
    case hiking
    case tour
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let address: String?
    let city: String?
}

struct EventDate: Codable {
    let startDate: String
    let endDate: String?
    let durationInDays: Int?
}

struct Price: Codable {
    let startPrice: Double
    let discountedPrice: Double?
}

struct Seats: Codable {
    let total: Int
    let available: Int
}

struct Event: Identifiable, Codable {
    let id: String
    let name: String
    let type: EventType
    let price: Price
    let date: EventDate
    let location: Location
    let seats: Seats
    let photos: [String]
    let organizerContact: String
    let requirements: [String]?
    let tags: [String]?
    var isFavorite: Bool
    let description: String
}

