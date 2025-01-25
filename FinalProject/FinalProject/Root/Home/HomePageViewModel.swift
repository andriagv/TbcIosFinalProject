//
//  HomePageViewModel.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation
import FirebaseDatabase
import Firebase



protocol HomePageViewModelProtocol {
    var events: [Event] { get }
    var forYouEvents: [Event] { get }
    var onDataLoaded: (() -> Void)? { get set }
    
    func loadData()
    func eventsCount() -> Int
    func forYouEventsCount() -> Int
}

final class HomePageViewModel: HomePageViewModelProtocol {
    private(set) var events: [Event] = []
    private(set) var forYouEvents: [Event] = []
    var onDataLoaded: (() -> Void)?
    private let databaseRef = Database.database().reference()
    
    init() {
        loadData()
    }
    
    func loadData() {
        loadTourEvents()
        loadFreeEvents()
    }
    
    private func loadTourEvents() {
        databaseRef.child("events")
            .queryOrdered(byChild: "type")
            .queryEqual(toValue: "tour")
            .observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else { return }
                
                var events: [Event] = []
                for child in snapshot.children {
                    guard let snapshot = child as? DataSnapshot,
                          let dict = snapshot.value as? [String: Any] else { continue }
                          
                    do {
                        let data = try JSONSerialization.data(withJSONObject: dict)
                        if let event = try? JSONDecoder().decode(Event.self, from: data) {
                            events.append(event)
                        }
                    } catch {
                        print("Parsing error: \(error)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.events = events
                    self.onDataLoaded?()
                    print("Loaded \(events.count) tour events")
                }
            }
    }
    
    private func loadFreeEvents() {
        databaseRef.child("events")
            .queryOrdered(byChild: "price/startPrice")
            .queryEqual(toValue: 0)
            .observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else { return }
                
                var events: [Event] = []
                for child in snapshot.children {
                    guard let snapshot = child as? DataSnapshot,
                          let dict = snapshot.value as? [String: Any] else { continue }
                          
                    do {
                        let data = try JSONSerialization.data(withJSONObject: dict)
                        if let event = try? JSONDecoder().decode(Event.self, from: data) {
                            events.append(event)
                        }
                    } catch {
                        print("Parsing error: \(error)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.forYouEvents = events
                    self.onDataLoaded?()
                }
            }
    }
    
    func eventsCount() -> Int {
        events.count
    }
    
    func forYouEventsCount() -> Int {
        forYouEvents.count
    }
}
